module Main where

import Data.Char
import Data.List
import Data.Map.Strict as Map
import Prelude hiding (Map)

main :: IO ()
main = print "hello"

type DaPhone = Map Digit [Char]

phoneMappings :: DaPhone
phoneMappings =
  Map.fromList
    [ ('1' :: Digit, ""),
      ('2' :: Digit, "ABC"),
      ('3', "DEF"),
      ('4', "GHI"),
      ('5', "JKL"),
      ('6', "MNO"),
      ('7', "PQRS"),
      ('8', "TUV"),
      ('9', "WXYZ"),
      ('*', "^"),
      ('0', "+_ "),
      ('#', ".,")
    ]

phoneMappingsReversed :: Map Char [Digit]
phoneMappingsReversed = reverseMap phoneMappings

reverseMap params = Map.fromListWith (++) pairs where pairs = [(v, [k]) | (k, vs) <- Map.toList params, v <- vs]

convo :: [String]
convo =
  [ "Wanna play 20 questions",
    "Ya",
    "U 1st haha",
    "Lol ok. Have u ever tasted alcohol",
    "Lol ya",
    "Wow ur cool haha. Ur turn",
    "Ok. Do u think I am pretty Lol",
    "Lol ya",
    "Just making sure rofl ur turn"
  ]

-- validButtons = "1234567890*#"
type Digit = Char

-- Valid presses: 1 and up
type Presses = Int

reverseTaps :: DaPhone -> Char -> [(Digit, Presses)]
reverseTaps _ c
  | c >= 'A' && c <= 'Z' = [('*', 1)] ++ myReverseTaps c
  | otherwise = myReverseTaps c

myReverseTaps :: Char -> [(Digit, Presses)]
myReverseTaps char = [(head (maybe "" id $ phoneMappingsReversed Map.!? toUpper char) :: Digit, toPresses char)]

toPresses :: Char -> Presses
toPresses char = (maybe 0 id $ elemIndex (toUpper char) (phoneMappings Map.! (head (phoneMappingsReversed Map.! (toUpper char))))) + 1

cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)]
cellPhonesDead _ string = Data.List.foldl (\acc char -> acc ++ reverseTaps phoneMappings char) [] string

fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps params = Data.List.foldl (\sum param ->  sum +(snd param)) 0 params


increaseMaybe (Just old) = Just (old +1)
increaseMaybe Nothing = Nothing

mostPopularLetter :: String -> Char
mostPopularLetter = fst . mostOften . Map.toList . letterByNumberOfOccurence

letterByNumberOfOccurenceWrong string = Data.List.foldl (\dict char -> Map.alter increaseMaybe char dict) Map.empty string

letterByNumberOfOccurence string = Data.List.foldl (\dict char -> countChar char dict ) Map.empty string
countChar c oldMap = newMap where newMap = Map.insertWith (+) c 1 oldMap

mostOften :: Ord a => [(t, a)] -> (t, a)
mostOften (x:xs) = maxTail x xs
  where maxTail currentMax [] = currentMax
        maxTail (m, n) (p:ps)
          | n < (snd p) = maxTail p ps
          | otherwise = maxTail (m, n) ps

coolestLtr :: [String] -> Char
coolestLtr strings = fst $ mostOften (Prelude.map (mostOften . Map.toList . letterByNumberOfOccurence) strings)
coolestWord :: [String] -> String
coolestWord strings = fst $ mostOften $ Map.toList $ wordsByNumberOfOccurence convo 
wordsByNumberOfOccurence strings = Data.List.foldl (\dict word -> countChar word dict ) Map.empty $ concat $Prelude.map words strings
