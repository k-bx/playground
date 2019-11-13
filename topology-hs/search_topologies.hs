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

renderTopology = Data.List.sort . map (map S.toList) . map S.toList . S.toList

dz_1_3 :: IO ()
dz_1_3 = do
  let res =
        S.fromList
          ([ tts
           | tts <- S.toList (findTopologies (S.fromList ['a', 'b', 'c', 'd']))
           , length tts == 4
           ])
  print $ length res
  print $ renderTopology res

dz_1_4 :: IO ()
dz_1_4 = do
  let res2 =
        S.fromList
          ([tts | tts <- S.toList (findTopologies (S.fromList ['a', 'b']))])
  print $ length res2
  print $ renderTopology res2
  let res3 =
        S.fromList
          ([tts | tts <- S.toList (findTopologies (S.fromList ['a', 'b', 'c']))])
  print $ length res3
  print $ renderTopology res3

main :: IO ()
main = dz_1_4
