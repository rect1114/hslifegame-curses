module Lifegame
    ( ScreenSize,
      Field,
      Line,
      Position,
      LinePosition,
      initField,
      fieldChange,
      printField,
      step,
      addSentinel,
      fieldToString,
      lineToString,
      fieldFlip
    ) where

type ScreenSize = (Int,Int)
type Field = [[Bool]]
type Line = [Bool]
type Position = (Int,Int)
type LinePosition = Int

step :: Field -> Field
step field = [[lifeOrDead field (x,y) | x <- [0,1..((length (field !! 0))-1)]]| y <- [0,1..((length field)-1)]]


lifeOrDead :: Field -> Position -> Bool
lifeOrDead field pos
    |((countLifeInMooreNH field pos) >= 4) = False
    |((countLifeInMooreNH field pos) == 3) = True
    |((countLifeInMooreNH field pos) >= 2) = (checkCell field pos)
    |otherwise = False
    

checkCell :: Field -> Position -> Bool
checkCell field (x,y) = field !! y !! x

countLifeInMooreNH :: Field -> Position -> Int
countLifeInMooreNH field (x,y) = (foldl (+) 0) (map (cellToZeroOne field) [(x-1,y-1),(x,y-1),(x+1,y-1),(x-1,y),(x+1,y),(x-1,y+1),(x,y+1),(x+1,y+1)])

cellToZeroOne :: Field -> Position -> Int
cellToZeroOne field (x,y)
    |x >= 0 && y >= 0 && x < (length (field !! 0)) && y < (length field) = boolToZeroOne (field !! y !! x)
    |otherwise = 0

boolToZeroOne :: Bool -> Int
boolToZeroOne cell = if cell then 1 else 0

initField :: ScreenSize -> Field
initField (width,height) = take height $ repeat $ take width $ repeat False

fieldFlip :: Field -> Position -> Field
fieldFlip field pos = 
    if checkCell field pos then
        fieldChange False field pos
    else
        fieldChange True field pos

fieldChange :: Bool -> Field -> Position -> Field
fieldChange newValue (line:lines) (x,y)
    |y == 0 = newLine:lines
    |otherwise = line:(fieldChange newValue lines (x,y-1))
    where
        newLine = lineChange x line newValue
        

lineChange :: LinePosition -> Line -> Bool -> Line
lineChange linePos (x:xs) newValue
    |linePos == 0 = newValue:xs
    |otherwise = x:(lineChange (linePos-1) xs newValue)


printField :: Field -> IO ()
printField field = putStrLn $ fieldToString field


addSentinel :: Field -> Field
addSentinel field = field_
    where
        field_ = [[x|x <- (cutHeadAndTail line)]|line <- (cutHeadAndTail field)]

cutHeadAndTail :: [a] -> [a]
cutHeadAndTail (x:xs) = init xs

lineToString :: Line -> String
lineToString line = jointStringList [if x then "#" else "_"|x <- line]

fieldToString :: Field -> String
fieldToString field = jointStringList $ map (++"\n") $ map lineToString field

jointStringList :: [String] -> String
jointStringList text = (foldl (++) "") text