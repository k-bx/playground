open import Level

data T {n} : Set n where
  ⊤ : T

data ⊥ {n} : Set n where

iAmLying : {n : Level}
  {Human : Set}
  {IsI : Human → Set}
  {IsPhraseAuthor : Human → Set n → Set n}
  → (phrase : Set n)
  → (human : Human)
  → IsI human
  → (iaffirm : IsPhraseAuthor human phrase)
  → Set n
iAmLying _ _ _ _ = ⊥

contradiction : {n : Level}
  {Human : Set}
  {IsI : Human → Set}
  {IsPhraseAuthor : Human → Set n → Set n}
  → (phrase : Set n)
  → (human : Human)
  → (isi : IsI human)
  → (iaffirm : IsPhraseAuthor human phrase)
  → ⊥ {n}
contradiction phrase human isi iaffirm =
  {!iAmLying phrase human isi iaffirm!}

-- This gives:
-- /Users/kb/workspace/playground-gh/am-i-lying/AmILying.agda:29,5-38
-- Set n !=< ⊥ of type Set (suc n)
-- when checking that the expression iAmLying phrase human isi iaffirm
-- has type ⊥
