{-# OPTIONS --safe --without-K #-}

module Injfin where

open import Data.Fin using (Fin; suc; zero; _≟_)
open import Data.Nat using (ℕ; suc; zero; _+_; compare; equal; greater; less)
open import Data.Nat.Properties using (+-comm)
open import Data.Bool using (not; T)
-- open import Relation.Nullary using (yes; no; ¬_)
-- open import Relation.Nullary using (does)
open import Data.Product using (Σ; Σ-syntax; proj₁; proj₂; _,_)
open import Data.Unit using (tt; ⊤)
open import Function using (_∘_; id; _⟨_⟩_)
open import Relation.Binary.PropositionalEquality using (subst; trans; cong; sym; _≡_; refl; _≢_)
open import Data.Empty                            using (⊥-elim; ⊥)

variable n m : ℕ

Goal : Set₁
Goal = ∀ {n m} → Fin n ≡ Fin m → n ≡ m

injfin : ∀ {n m} → Fin n ≡ Fin m → n ≡ m
injfin {zero} {zero} Finn≡Finm = refl
injfin {zero} {suc zero} Finn≡Finm
  = {!!}
  -- rewrite cong Data.Fin.toℕ Finn≡Finm = {!!}
injfin {Data.Fin.0F} {suc (suc m)} Finn≡Finm = {!!}
injfin {suc n} {m} Finn≡Finm = {!!}
