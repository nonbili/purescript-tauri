module Tauri.FS
  ( BaseDirectory(..)
  , readTextFile
  , writeTextFile
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn2, runEffectFn2)

data BaseDirectory
  = Audio
  | Cache
  | Config
  | Data
  | LocalData
  | Desktop
  | Document
  | Download
  | Executable
  | Font
  | Home
  | Picture
  | Public
  | Runtime
  | Template
  | Video
  | Resource
  | App

instance encodeJsonBaseDirectory :: EncodeJson BaseDirectory where
  encodeJson dir = encodeJson case dir of
    Audio -> 1
    Cache -> 2
    Config -> 3
    Data -> 4
    LocalData -> 5
    Desktop -> 6
    Document -> 7
    Download -> 8
    Executable -> 9
    Font -> 10
    Home -> 11
    Picture -> 12
    Public -> 13
    Runtime -> 14
    Template -> 15
    Video -> 16
    Resource -> 17
    App -> 18

type FsOptions =
  { dir :: Maybe BaseDirectory
  }

type FilePath = String

foreign import unsafeRequireFS :: forall r. Record r

fs ::
  { readTextFile :: EffectFn2 FilePath Json (Promise String)
  , writeFile :: EffectFn2 FilePath Json (Promise Unit)
  }
fs = unsafeRequireFS

readTextFile :: String -> FsOptions -> Aff String
readTextFile path opts = toAffE $ runEffectFn2 fs.readTextFile path (encodeJson opts)

writeTextFile :: String -> FsOptions -> Aff Unit
writeTextFile path opts = toAffE $ runEffectFn2 fs.writeFile path (encodeJson opts)
