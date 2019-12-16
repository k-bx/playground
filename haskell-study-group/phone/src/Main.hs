module Main where

import qualified Data.Char
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

main :: IO ()
main = do
  putStrLn "hello world"
