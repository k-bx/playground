module Main where

import qualified Data.Char
import qualified Data.List

type DaPhone = Char -> [(Digit, Presses)]

phone :: DaPhone
phone c =
  if Data.Char.isUpper c
    then [('*', 1)] ++ phone (Data.Char.toLower c)
    else case c of
           '1' -> [('1', 1)]
           'a' -> [('2', 1)]
           'b' -> [('2', 2)]
           'c' -> [('2', 3)]
           '2' -> [('2', 4)]
           'd' -> [('3', 1)]
           'e' -> [('3', 2)]
           'f' -> [('3', 3)]
           '3' -> [('3', 4)]
           'g' -> [('4', 1)]
           'h' -> [('4', 2)]
           'i' -> [('4', 3)]
           '4' -> [('4', 4)]
           'j' -> [('5', 1)]
           'k' -> [('5', 2)]
           'l' -> [('5', 3)]
           '5' -> [('5', 4)]
           'm' -> [('6', 1)]
           'n' -> [('6', 2)]
           'o' -> [('6', 3)]
           '6' -> [('6', 4)]
           'p' -> [('7', 1)]
           'q' -> [('7', 2)]
           'r' -> [('7', 3)]
           's' -> [('7', 4)]
           '7' -> [('8', 5)]
           't' -> [('8', 1)]
           'u' -> [('8', 2)]
           'v' -> [('8', 3)]
           '8' -> [('8', 4)]
           'w' -> [('9', 1)]
           'x' -> [('9', 2)]
           'y' -> [('9', 3)]
           'z' -> [('9', 4)]
           '9' -> [('9', 5)]
           ' ' -> [('0', 1)]
           '0' -> [('0', 2)]
           '.' -> [('#', 1)]
           ',' -> [('#', 2)]
           '#' -> [('#', 3)]
           _ -> error "impossible!"

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
reverseTaps = id

cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)]
cellPhonesDead = concatMap . reverseTaps

-- How many times do digits need to be pressed for each message?
fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps xs = sum (map snd xs)

lettersPopularity :: String -> Char -> Int
lettersPopularity str =
  Data.List.foldl'
    (\f chr ->
       (\c ->
          if c == chr
            then f c + 1
            else f c))
    (\_c -> 0)
    str

-- What was the most popular letter for each message? What was
-- its cost? You’ll want to combine reverseTaps and fingerTaps to
-- figure out what it cost in taps. reverseTaps is a list because you
-- need to press a different button in order to get capitals.
mostPopularLetter :: String -> Char
mostPopularLetter str =
  fst . snd $
  Data.List.foldl'
    (\(f, (curChar, count)) chr ->
       let f' c =
             if c == chr
               then f c + 1
               else f c
           nextLeader =
             if f' chr > count
               then (chr, f' chr)
               else (curChar, count)
        in (f', nextLeader))
    ((\_c -> (0 :: Int)), ('a', 0))
    str

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
  fst . snd $
  Data.List.foldl'
    (\(f, (curChar, count)) chr ->
       let f' c =
             if c == chr
               then f c + 1
               else f c
           nextLeader =
             if f' chr > count
               then (chr, f' chr)
               else (curChar, count)
        in (f', nextLeader))
    ((\_c -> (0 :: Int)), ("", 0))
    (concatMap words strings)

main :: IO ()
main = do
  putStrLn "hello world"
