module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = do
    let field = (foldl (fieldChange True) (initField (10,10))) [(0,0),(0,1),(0,2)]
    printField field

    print $ countLifeInMooreNH field (0,1)

type ScreenSize = (Int,Int)
type Field = [[Bool]]
type Line = [Bool]
type Position = (Int,Int)
type LinePosition = Int

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
printField field = do
    let field_ = fieldToString field
    putStrLn field_

lineToString :: Line -> String
lineToString line = jointStringList [if x then "#" else "_"|x <- line]

fieldToString :: Field -> String
fieldToString field = jointStringList $ map (++"\n") $ map lineToString field

jointStringList :: [String] -> String
jointStringList text = (foldl (++) "") text