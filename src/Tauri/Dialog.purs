module Tauri.Dialog
  ( OpenDialogOptions
  , open
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, runEffectFn1)

type OpenDialogOptions =
  { directory :: Boolean
  }

foreign import dialog ::
  { open :: EffectFn1 OpenDialogOptions (Promise String)
  }

open :: OpenDialogOptions -> Aff String
open opts = toAffE $ runEffectFn1 dialog.open opts
