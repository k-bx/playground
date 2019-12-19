{-# LANGUAGE ScopedTypeVariables #-}
import Prelude hiding (lookup, maxOccurances)
import Data.Map.Strict hiding (map, foldl, filter)
import Data.Maybe; import Data.Char; import Data.List; import Data.Function

type Digit = Char
type Presses = Int
type DaPhone = Map Digit [Char]
type RevDaPhone = Map Char Digit

daPhone :: DaPhone = fromList
    [   ('1', "1"),     ('2', "abc2"),  ('3', "def3"),
        ('4', "ghi4"),  ('5', "jkl5"),  ('6', "mno6"),
        ('7', "pqrs7"), ('8', "tuv8"),  ('9', "wxyz9"),
                        ('0', " 0"),    ('#', ".,#")    ]

reversePhone :: DaPhone -> RevDaPhone = fromList . concatMap (\(k, v) -> map (\c -> (c, k)) v) . toList

convo :: [String] =
 [ "Wanna play 20 questions",
   "Ya",
   "U 1st haha",
   "Lol ok. Have u ever tasted alcohol lol",
   "Lol ya",
   "Wow ur cool haha. Ur turn",
   "Ok. Do u think I am pretty Lol",
   "Lol ya",
   "Haha thanks just making sure rofl ur turn" ]

reverseTaps :: DaPhone -> Char -> [(Digit, Presses)]
reverseTaps phone c = let digit = (reversePhone phone) ! toLower c
                          presses = (+1) $ fromJust $ elemIndex (toLower c) (phone ! digit)
                       in (if isUpper c then [('*', 1)] else []) ++ [(digit, presses)]

cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)]
cellPhonesDead phone s = concatMap (reverseTaps phone) s

maxOccurances :: Eq a => [a] -> a
maxOccurances xs = snd $ last $ sortBy (compare `on` fst) $ map (\c -> (length $ filter (==c) xs, c)) $ (nub xs)

fingerTaps :: [(Digit, Presses)] -> Presses = foldl (\acc t -> acc + snd t) 0
mostPopularLetter :: String -> Char = maxOccurances
coolestLtr :: [String] -> Char = mostPopularLetter . concat
coolestWord :: [String] -> String = maxOccurances . concatMap words
