module Main where

import qualified Data.List
import qualified Data.Maybe
import qualified Data.Set as S

type Set a = S.Set a

type Topology a = Set (Set a)

findTopologies :: Ord a => Set a -> Set (Topology a)
findTopologies xs = S.filter (isTopology xs) (genAllSubsets (genAllSubsets xs))

genAllSubsets :: Ord a => Set a -> Set (Set a)
genAllSubsets xs =
  S.fromList $ map S.fromList $ Data.List.subsequences $ S.toList xs

isTopology :: Ord a => Set a -> Set (Set a) -> Bool
isTopology xs tts =
  (S.empty `S.member` tts && xs `S.member` tts) &&
  (all
     (== True)
     [S.union ts1 ts2 `S.member` tts | ts1 <- S.toList tts, ts2 <- S.toList tts]) &&
  (all
     (== True)
     [ (S.intersection ts1 ts2) `S.member` tts
     | ts1 <- S.toList tts
     , ts2 <- S.toList tts
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
  print $ Data.List.sort $ map (map S.toList) $ map S.toList $ S.toList res

-- 43
--
-- [ ["", "a", "ab", "abcd"]
-- , ["", "a", "abc", "abcd"]
-- , ["", "a", "abcd", "abd"]
-- , ["", "a", "abcd", "ac"]
-- , ["", "a", "abcd", "acd"]
-- , ["", "a", "abcd", "ad"]
-- , ["", "a", "abcd", "bcd"]
-- , ["", "ab", "abc", "abcd"]
-- , ["", "ab", "abcd", "abd"]
-- , ["", "ab", "abcd", "b"]
-- , ["", "ab", "abcd", "cd"]
-- , ["", "abc", "abcd", "ac"]
-- , ["", "abc", "abcd", "b"]
-- , ["", "abc", "abcd", "bc"]
-- , ["", "abc", "abcd", "c"]
-- , ["", "abc", "abcd", "d"]
-- , ["", "abcd", "abd", "ad"]
-- , ["", "abcd", "abd", "b"]
-- , ["", "abcd", "abd", "bd"]
-- , ["", "abcd", "abd", "c"]
-- , ["", "abcd", "abd", "d"]
-- , ["", "abcd", "ac", "acd"]
-- , ["", "abcd", "ac", "bd"]
-- , ["", "abcd", "ac", "c"]
-- , ["", "abcd", "acd", "ad"]
-- , ["", "abcd", "acd", "b"]
-- , ["", "abcd", "acd", "c"]
-- , ["", "abcd", "acd", "cd"]
-- , ["", "abcd", "acd", "d"]
-- , ["", "abcd", "ad", "bc"]
-- , ["", "abcd", "ad", "d"]
-- , ["", "abcd", "b", "bc"]
-- , ["", "abcd", "b", "bcd"]
-- , ["", "abcd", "b", "bd"]
-- , ["", "abcd", "bc", "bcd"]
-- , ["", "abcd", "bc", "c"]
-- , ["", "abcd", "bcd", "bd"]
-- , ["", "abcd", "bcd", "c"]
-- , ["", "abcd", "bcd", "cd"]
-- , ["", "abcd", "bcd", "d"]
-- , ["", "abcd", "bd", "d"]
-- , ["", "abcd", "c", "cd"]
-- , ["", "abcd", "cd", "d"]
-- ]
