module Main where

import qualified Data.List
import qualified Data.Maybe
import qualified Data.Set as S

type Set a = S.Set a

type Topology a = Set (Set a)

findTopologies :: Ord a => Set a -> Set (Topology a)
findTopologies xs = S.filter (isTopology xs) (genAllSubsets (genAllSubsets xs))

genAllSubsets :: Ord a => Set a -> Set (Set a)
genAllSubsets xs = S.fromList $ map S.fromList $ Data.List.subsequences $ S.toList xs

isTopology :: Ord a => Set a -> Set (Set a) -> Bool
isTopology xs tts =
  (S.empty `S.member` tts && xs `S.member` tts) &&
  (any
     (== True)
     [ S.union ts1 ts2 == ts3
     | ts1 <- S.toList tts
     , ts2 <- S.toList tts
     , ts3 <- S.toList tts
     ]) &&
  (any
     (== True)
     [ (S.intersection ts1 ts2) == ts3
     | ts1 <- S.toList tts
     , ts2 <- S.toList tts
     , ts3 <- S.toList tts
     ])

main :: IO ()
main = do
  let res = 
    S.fromList
      ([ tts
       | tts <- S.toList (findTopologies (S.fromList ['a', 'b', 'c', 'd']))
       , length tts == 4
       ])
  print $ length res

-- fromList
--   [ fromList [fromList "", fromList "a", fromList "ab", fromList "abcd"]
--   , fromList [fromList "", fromList "a", fromList "abc", fromList "abcd"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "abd"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "ac"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "acd"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "ad"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "b"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "bc"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "bcd"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "bd"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "c"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "cd"]
--   , fromList [fromList "", fromList "a", fromList "abcd", fromList "d"]
--   , fromList [fromList "", fromList "ab", fromList "abc", fromList "abcd"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "abd"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "ac"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "acd"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "ad"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "b"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "bc"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "bcd"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "bd"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "c"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "cd"]
--   , fromList [fromList "", fromList "ab", fromList "abcd", fromList "d"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "abd"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "ac"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "acd"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "ad"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "b"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "bc"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "bcd"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "bd"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "c"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "cd"]
--   , fromList [fromList "", fromList "abc", fromList "abcd", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "ac"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "acd"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "ad"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "b"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "bc"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "bcd"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "abd", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "acd"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "ad"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "b"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "bc"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "bcd"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "ac", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "ad"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "b"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "bc"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "bcd"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "acd", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "b"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "bc"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "bcd"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "ad", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "b", fromList "bc"]
--   , fromList [fromList "", fromList "abcd", fromList "b", fromList "bcd"]
--   , fromList [fromList "", fromList "abcd", fromList "b", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "b", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "b", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "b", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "bc", fromList "bcd"]
--   , fromList [fromList "", fromList "abcd", fromList "bc", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "bc", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "bc", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "bc", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "bcd", fromList "bd"]
--   , fromList [fromList "", fromList "abcd", fromList "bcd", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "bcd", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "bcd", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "bd", fromList "c"]
--   , fromList [fromList "", fromList "abcd", fromList "bd", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "bd", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "c", fromList "cd"]
--   , fromList [fromList "", fromList "abcd", fromList "c", fromList "d"]
--   , fromList [fromList "", fromList "abcd", fromList "cd", fromList "d"]
--   ]
