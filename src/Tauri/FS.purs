module Tauri.FS
  ( BaseDirectory(..)
  , FsOptions
  , FilePath
  , readTextFile
  , writeTextFile
  , readDir
  , createDir
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Either (either)
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

type FsTextFileOption =
  { path :: String
  , contents :: String
  }

type FileEntry =
  { path :: String
  , name :: Maybe String
  }

type FilePath = String

foreign import unsafeRequireFS :: forall r. Record r

fs ::
  { readTextFile :: EffectFn2 FilePath Json (Promise String)
  , writeFile :: EffectFn2 FsTextFileOption Json (Promise Unit)
  , readDir :: EffectFn2 FilePath Json (Promise Json)
  , createDir :: EffectFn2 FilePath Json (Promise Unit)
  }
fs = unsafeRequireFS

readTextFile :: FilePath -> FsOptions -> Aff String
readTextFile path opts = toAffE $ runEffectFn2 fs.readTextFile path (encodeJson opts)

writeTextFile :: FilePath -> String -> FsOptions -> Aff Unit
writeTextFile path contents opts =
  toAffE $ runEffectFn2 fs.writeFile { path, contents } (encodeJson opts)

-- | Recursive not supported yet.
readDir :: FilePath -> FsOptions -> Aff (Array FileEntry)
readDir path opts = do
  obj <- toAffE $ runEffectFn2 fs.readDir path (encodeJson opts)
  pure $ either (pure []) identity $ decodeJson obj

-- | Recursive not supported yet.
createDir :: FilePath -> FsOptions -> Aff Unit
createDir path opts = do
  toAffE $ runEffectFn2 fs.createDir path (encodeJson opts)
