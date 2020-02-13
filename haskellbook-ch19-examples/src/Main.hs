{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (FromJSON(..), Value(..), (.:))
import Data.Aeson.Types (typeMismatch)
import qualified Data.UUID as UUID
import qualified Data.UUID.V4 as UUIDv4
import Control.Monad.Logger
import Control.Monad.Trans.Resource
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Database.Persist.Postgresql (withPostgresqlConn)
import Database.Persist.Sql (SqlPersistT)
import qualified Database.Persist.Sql as P
import System.Environment
import System.Log.FastLogger (fromLogStr)
import Web.Scotty
import qualified Data.ByteString.Char8 as BSC8
import Data.Time.Clock

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["scotty"] -> mainScotty
    _ -> putStrLn "howdy!"

mainScotty :: IO ()
mainScotty =
  scotty 3000 $ do
    get "/:word" $ do
      beam <- param "word"
      html (mconcat ["<h1>Scotty, ", beam, " me up!</h1>"])

instance MonadLogger IO where
  monadLoggerLog _loc _logSource _logLevel msg =
    putStrLn (BSC8.unpack (fromLogStr (toLogStr msg)))

runDb :: SqlPersistT (ResourceT IO) a -> IO a
runDb query = do
  let params :: [(T.Text, T.Text)]
      params = undefined
  let connStr =
        foldr
          (\(k, v) t -> t <> (T.encodeUtf8 $ k <> "=" <> v <> " "))
          ""
          params
  runResourceT . withPostgresqlConn connStr $ P.runSqlConn query

offsetCurrentTime :: NominalDiffTime -> IO UTCTime
offsetCurrentTime offset =
  fmap (addUTCTime (offset * 24 * 3600)) $ getCurrentTime

textUuid :: IO T.Text
textUuid = fmap (T.pack . UUID.toString) UUIDv4.nextRandom

-- parseJSON :: Value -> Parser a
-- (.:) :: FromJSON a
--      => Object
--      -> Text
--      -> Parser a

data Payload =
  Payload
  { payloadFrom :: String
  , payloadTo :: String
  , payloadSubject :: String
  , payloadBody :: String
  , payloadOffsetSeconds :: Int
  }

instance FromJSON Payload where
  parseJSON (Object v) =
    Payload <$> v .: "from"
            <*> v .: "to"
            <*> v .: "subject"
            <*> v .: "body"
            <*> v .: "offset_seconds"
  parseJSON v = typeMismatch "Payload" v
