module Phone where

import Data.List
import Data.Char
import Data.String

import qualified Data.Map as Map

convo :: [String]
convo = [
    "Wanna play 20 questions",
    "Ya",
    "U 1st haha",
    "Lol ok. Have u ever tasted alcohol lol",
    "Lol ya",
    "Wow ur cool haha. Ur turn",
    "Ok. Do u think I am pretty Lol",
    "Lol ya",
    "Haha thanks just making sure rofl ur turn"]



-- fill in the rest.
-- 1>
data DaPhone = DaPhone [DaButton]

type DaButton = (Digit, [Char])

nb::DaButton -> DaButton
nb (d, sx) = (d, sx ++ [d])

defPhone = DaPhone [
    nb ('1', "" ),
    nb ('2', "abc" ),
    nb ('3', "def" ),
    nb ('4', "ghi" ),
    nb ('5', "jkl" ),
    nb ('6', "mno" ),
    nb ('7', "pqrs" ),
    nb ('8', "tuv" ),
    nb ('9', "wxyz" ),
    nb ('*', "^" ),
    nb ('0', "+ " ),
    nb ('#', ".," )] 


-- validButtons = "1234567890*#"
type Digit = Char
-- Valid presses: 1 and up
type Presses = Int
reverseTaps :: DaPhone -> Char -> [(Digit, Presses)]
reverseTaps (DaPhone bs) sym
    | sym == '^' = undefined
    | isUpper sym = go '^' ++ go (toLower sym)
    | otherwise = go sym
        where 
            b2ts (d, sx) s = case elemIndex s sx of
                Nothing -> undefined
                Just index -> [(d, index + 1)]
            go s = case find (elem s.snd) bs of 
                Nothing -> undefined
                Just b -> b2ts b s 
 

-- assuming the default phone definition
-- 'a' -> [('2', 1)]
-- 'A' -> [('*', 1), ('2', 1)]
cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)] 
cellPhonesDead phone = concat . map (reverseTaps phone)

-- 2>
txtToTaps = map (cellPhonesDead defPhone) 
-- txtToTaps convo

fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps = sum . map  snd

-- 3>
txtToTapsCount = fingerTaps . concat . map  (cellPhonesDead defPhone)
-- txtToTapsCount convo


mostPopularLetter :: String -> Char
mostPopularLetter = fst . getMax . getMap .map toLower 
    where 
        update = Map.insertWith (+)
        calc key = update key 1 
        getMap = foldr calc Map.empty
        getMax = maximumBy (\(_, a) (_,b) -> compare a b) . Map.toList 


mostPopularLetterAndCost :: String -> (Char, Presses) 
mostPopularLetterAndCost txt = (leter, cost)
    where 
        leter =  mostPopularLetter txt
        cmp:: Char -> Bool
        cmp = (== leter).toLower
        cost = fingerTaps . cellPhonesDead defPhone .filter cmp $ txt

-- 4>
-- map mostPopularLetterAndCost convo


-- 5>
coolestLtr :: [String] -> Char
coolestLtr = mostPopularLetter.concat
-- coolestLtr convo


coolestWord :: [String] -> String
coolestWord txt = fst . getMax . getMap $ ws 
    where 
        ws = words . map toLower . unlines  $ txt
        calc key = Map.insertWith (+) key 1 
        getMap = foldr calc Map.empty
        getMax = maximumBy (\(_, a) (_,b) -> compare a b) . Map.toList 
-- coolestWord convo
