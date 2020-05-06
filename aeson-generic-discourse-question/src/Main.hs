#!/usr/bin/env stack
-- stack --resolver=lts-13.19 script
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeInType #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE InstanceSigs #-}
module GenericDiff where

import Data.Maybe
import Data.Functor.Identity
import qualified Data.Text as T
import GHC.Generics
import Type.Reflection
import Data.Aeson (Value, Object, Options, FromArgs(..), fieldLabelModifier, gParseJSON, withObject)
import Data.Aeson.Types
import qualified Data.HashMap.Strict as H

data Diff a = Changed a | Unchanged

genericParseDiff :: (Generic a, ParseJSONDiff (Rep a)) => Options -> Value -> Parser a
genericParseDiff opts v = to <$> withObject "Object diff" (parseJSONDiff opts) v

class ParseJSONDiff f where
  parseJSONDiff :: Options -> Object -> Parser (f a)

instance ParseJSONDiff f => ParseJSONDiff (D1 x f) where
  parseJSONDiff opts obj = M1 <$> parseJSONDiff @f opts obj

instance ParseJSONDiff f => ParseJSONDiff (C1 x f) where
  parseJSONDiff opts obj = M1 <$> parseJSONDiff @f opts obj

instance (ParseJSONDiff a, ParseJSONDiff b) => ParseJSONDiff (a :*: b) where
  parseJSONDiff opts obj =
    (:*:) <$> parseJSONDiff opts obj
          <*> parseJSONDiff opts obj

instance (Selector s, FromJSON a) => ParseJSONDiff (S1 s (K1 i a)) where
  parseJSONDiff opts obj = do
      fv <- obj .: label
      M1 . K1 <$> pure fv -- gParseJSON opts NoFromArgs fv -- <?> Key label
    where
      label = T.pack $ fieldLabelModifier opts sname
      sname = selName (undefined :: M1 _i s _f _p)

instance {-# OVERLAPPING #-} (Selector s, FromJSON a) => ParseJSONDiff (S1 s (K1 i (Diff a))) where
  parseJSONDiff :: Options -> Object -> Parser ((S1 s (K1 i (Diff a))) b)
  parseJSONDiff opts obj =
      case H.lookup label obj of
        Just fv ->
          let -- inner :: Parser a0
              inner = fmap to (gParseJSON opts NoFromArgs fv)
          in M1 . K1 . Changed . runIdentity <$> inner
        Nothing -> M1 . K1 <$> pure Unchanged
    where
      label = T.pack $ fieldLabelModifier opts sname
      sname = selName (undefined :: M1 _i s _f _p)

instance ParseJSONDiff U1 where
  parseJSONDiff _ _ = pure U1
