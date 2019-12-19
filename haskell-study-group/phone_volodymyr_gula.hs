-- -----------------------------------------
-- | 1      | 2 ABC  | 3 DEF  |
-- _________________________________________
-- | 4 GHI  | 5 JKL  | 6 MNO  |
-- -----------------------------------------
-- | 7 PQRS | 8 TUV  | 9 WXYZ |
-- -----------------------------------------
-- |   * ^  | 0 + _  | # .,   |
-- -----------------------------------------

-- 2     -> 'A'
-- 22    -> 'B'
-- 222   -> 'C'
-- 2222  -> '2'
-- 22222 -> 'A'

-- 1.
import Data.Char (ord, chr, isUpper, toLower)
import Data.List (find, elemIndex)
import Data.Maybe (fromJust)
data DaPhone = DaPhone [(Char, String)] deriving (Eq, Show)

phone = DaPhone [
  ('1', ""),
  ('2', "abc"),
  ('3', "def"),
  ('4', "ghi"),
  ('5', "jkl"),
  ('6', "mno"),
  ('7', "pqrs"),
  ('8', "tuv"),
  ('9', "wxyz"),
  ('0', "+ "),
  ('*', "^"),
  ('#', ".,")]

-- 2.
convo :: [String]
convo =
  ["Wanna play 20 questions",
    "Ya",
    "U 1st haha",
    "Lol ok. Have u ever tasted alcohol",
    "Lol ya",
    "Wow ur cool haha. Ur turn",
    "Ok. Do u think I am pretty Lol",
    "Lol ya",
    "Just making sure rofl ur turn"]

type Digit = Char
type Presses = Int

getButtons :: DaPhone -> Char -> [(Char, String)]
getButtons phone@(DaPhone xs) c = process xs c []
  where process (btn:btns) char result
          | isUpper char = process xs (toLower char) (result ++ (getButtons phone '*'))
          | elem char . snd $ btn = result ++ [btn]
          | fst btn == char = result ++ [btn]
          | otherwise = process btns char result

reverseTaps :: DaPhone -> Char -> [(Digit, Presses)]
reverseTaps phone char = map (\btn@(digit, string) -> (digit, process btn)) buttons
  where buttons = getButtons phone char
        process (digit, string)
          | digit == '*' = 1
          | otherwise = (+1) . length $ takeWhile (/= (toLower char)) $ string

cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)]
cellPhonesDead phone xs = foldr (\x acc -> (reverseTaps phone x) ++ acc) [] xs

-- 3.
fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps = foldr (\(_, num) acc -> num + acc) 0

-- 4.
mostPopularLetter :: String -> Char
mostPopularLetter str@(x:xs) =
  foldr (\x acc -> if (process str x) > (process str acc) then x else acc) x xs
    where process xs char = foldr (\x acc -> if x == char then acc + 1 else acc) 0 xs

-- 5.
coolestLtr :: [String] -> Char
coolestLtr = mostPopularLetter . concat

coolestWord :: [String] -> String
coolestWord xs = foldr (\x acc -> if (process allWords x) > (process allWords acc) then x else acc) [] allWords
  where allWords = foldr ((++) . words ) [] xs
        process words item = length $ filter (== item) words
