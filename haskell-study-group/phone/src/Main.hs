module Main where

import qualified Data.Char
import Data.Function (on)
import qualified Data.List

data DaPhone =
  DaPhone
    { phnNumbers :: [(Digit, [Char])]
    }

phone :: DaPhone
phone =
  DaPhone
    { phnNumbers =
        [ ('1', "1")
        , ('2', "abc2")
        , ('3', "def3")
        , ('4', "ghi4")
        , ('5', "jkl5")
        , ('6', "mno6")
        , ('7', "pqrs7")
        , ('8', "tuv8")
        , ('9', "wxyz9")
        , ('0', " 0")
        , ('#', ".,#")
        ]
    }

convo :: [String]
convo =
  [ "Wanna play 20 questions"
  , "Ya"
  , "U 1st haha"
  , "Lol ok. Have u ever tasted alcohol"
  , "Lol ya"
  , "Wow ur cool haha. Ur turn"
  , "Ok. Do u think I am pretty Lol"
  , "Lol ya"
  , "Just making sure rofl ur turn"
  ]

-- validButtons = "1234567890*#"
type Digit = Char

-- Valid presses: 1 and up
type Presses = Int

reverseTaps :: DaPhone -> Char -> [(Digit, Presses)]
reverseTaps phone chr =
  if Data.Char.isUpper chr
    then [('*', 1)] ++ reverseTaps phone (Data.Char.toLower chr)
    else foldr
           (\(dig, symbols) acc ->
              case Data.List.elemIndex chr symbols of
                Nothing -> acc
                Just i -> [(dig, (i + 1))])
           []
           (phnNumbers phone)

cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)]
cellPhonesDead phone str =
  Data.List.foldl' (\acc chr -> reverseTaps phone chr ++ acc) [] str

-- How many times do digits need to be pressed for each message?
fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps xs = sum (map snd xs)

lettersPopularity :: String -> [(Char, Int)]
lettersPopularity str =
  Data.List.foldl'
    (\acc chr ->
       case Data.List.lookup chr acc of
         Nothing -> [(chr, 1)] ++ acc
         Just count -> [(chr, count + 1)] ++ acc)
    []
    str

-- What was the most popular letter for each message? What was
-- its cost? You’ll want to combine reverseTaps and fingerTaps to
-- figure out what it cost in taps. reverseTaps is a list because you
-- need to press a different button in order to get capitals.
mostPopularLetter :: String -> Char
mostPopularLetter str =
  fst (Data.List.maximumBy (compare `on` snd) (lettersPopularity str))

mostPopularLetterCost :: String -> (Char, Int)
mostPopularLetterCost str =
  let letter = mostPopularLetter str
      occurrencesNum = length (filter (== letter) str)
   in (letter, occurrencesNum * (fingerTaps (reverseTaps phone letter)))

coolestLtr :: [String] -> Char
coolestLtr strs =
  let str = Data.List.concat strs
   in mostPopularLetter str

coolestWord :: [String] -> String
coolestWord strings =
  let wordPopularity :: [String] -> [(String, Int)]
      wordPopularity words =
        Data.List.foldl'
          (\acc word ->
             case Data.List.lookup word acc of
               Nothing -> [(word, 1)] ++ acc
               Just count -> [(word, count + 1)] ++ acc)
          []
          words
      allWords = Data.List.words (Data.List.unlines strings)
   in fst (Data.List.maximumBy (compare `on` snd) (wordPopularity allWords))


main :: IO ()
main = do
  putStrLn "hello world"
