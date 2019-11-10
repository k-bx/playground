module TheMissingLink where

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; cong-app)
open Eq.≡-Reasoning
open import Data.Product public using (Σ; Σ-syntax; _×_; _,_; proj₁; proj₂; map₁; map₂)
open import Data.Sum
open import Level


Type : (ℓ : Level) → Set (suc ℓ)
Type ℓ = Set ℓ

Type₀ : Type (suc zero)
Type₀ = Type zero

Type₁ : Type (suc (suc zero))
Type₁ = Type (suc zero)

infix 0 _≃_
record _≃_ {l m} (A : Type l) (B : Type m) : Type (l ⊔ m) where
  field
    to   : A → B
    from : B → A
    from∘to : ∀ (x : A) → from (to x) ≡ x
    to∘from : ∀ (y : B) → to (from y) ≡ y
open _≃_

-- infix 0 _≃_
-- record _≃_ (A : Type) (B : Type) : Type where
--   field
--     to   : A → B
--     from : B → A
--     from∘to : ∀ (x : A) → from (to x) ≡ x
--     to∘from : ∀ (y : B) → to (from y) ≡ y
-- open _≃_

infix 0 _≲_
record _≲_ (A B : Type₀) : Type₀ where
  field
    to      : A → B
    from    : B → A
    from∘to : ∀ (x : A) → from (to x) ≡ x
open _≲_


-- postulate  -- Univalence axiom
--   coe-equiv : ∀ {A B : Set} → A ≡ B → A ≃ B
--   ua : ∀ {l} {A B : Set l} → (A ≃ B) → A ≡ B
--   ua-η : {A B : Set} (p : A ≡ B) → ua (coe-equiv p) ≡ p

--
-- copy of old stuff, I can do better now (like infinite unions)
--
-- record Topology : (X : Set) → (τ : (X → Set) → Set) →  Set₁ where
-- Topology X τ =
--   Σ[ P ∈ (X → Set) ]
--   Σ[ _ ∈ τ P ]
--   Σ[ _ ∈ τ P-id ]
--   Σ[ _ ∈ τ P₀ ]
--   Σ[ _ ∈ (∀ (A B : X → Set) → (τ A) → (τ B) → (τ (λ x → A x ⊎ B x))) ]
--   Σ[ _ ∈ (∀ (A B : X → Set) → (τ A) → (τ B) → (τ (λ x → A x × B x))) ]
--   ⊤

-- This seems non-controversial at this point
--
-- SetOfSubsets : Set → Set₁
-- SetOfSubsets X = (X → Set) → Set

Pred : Type₀ → Type₁
Pred X = X → Type₀

PredOnPred : Type₀ → Type₁
PredOnPred X = (X → Type₀) → Type₀

SetOfSubs : (X : Type₀) → (ℙ : PredOnPred X) → Type₁
SetOfSubs X ℙ = Σ[ P ∈ Pred X ] (PredOnPred X)

-- How do we say that something is present in a given set of subsets?
--
-- Probably give back the predicate and show all elements satisfying
-- it are isomorphic to S?
--
_∈s_ : {X : Type₀} → (S : Type₀) → (PredOnPred X) → Type₁
_∈s_ {X} S ℙ =
  Σ[ P ∈ (X → Type₀) ]
  ( ∀ (x : X) → (P x ≃ S))

--
-- Type of a potentially infinite union of subsets of X indexed by
-- type J is a triple of index, type by that index (no proof of that),
-- and a proof that it's in the set of subsets
--
--
-- Union : {X : Set} → (J : Set) → (𝐵 : SetOfSubsets X) → Set₁
-- Union J 𝐵 = Σ[ j ∈ J ] Σ[ Bⱼ ∈ Set ] (Bⱼ ∈s 𝐵)

Union : {X : Type₀} → (J : Type₀) → (𝐵 : PredOnPred X) → Type₁
Union J 𝐵 =
  Σ[ j ∈ J ]
  Σ[ Bⱼ ∈ Type₀ ]
  (Bⱼ ∈s 𝐵)

UnionTruncation : {X : Type₀} → (J : Type₀) → (𝐵 : PredOnPred X) → Type₁
UnionTruncation J 𝐵 =
  (j : Union J 𝐵) → (k : Union J 𝐵) → (proj₁ j ≡ proj₁ k) → j ≡ k

record UnionRec {X : Type₀} (J : Type₀) (𝐵 : PredOnPred X) : Type₁ where
  field
    getJ : J
    getBj : Type₀
    getBjInB : getBj ∈s 𝐵
open UnionRec

-- UnionRec : {X : Set} → (J : Set) → (𝐵 : SetOfSubsets X) → Set₁
-- UnionRec : J 𝐵 = Σ[ j ∈ J ] Σ[ Bⱼ ∈ Set ] (Bⱼ ∈s 𝐵)

-- "Topology without tears" 2.3.2 constructively
--
-- 2.3.2 Let (X, τ) be a topological space. A family B of open subsets
-- of X is a basis for τ if and only if for any point x belonging to
-- any open set U , there is a B ∈ B such that x ∈ B ⊆ U.
--
-- This only proves the second part (given ... proves that B is a basis)
--
prop232
  : (X : Type₀)
  → (τ : PredOnPred X)
  → (𝐵 : PredOnPred X)
  → (given₁ : ∀ (U : Type₀)
            → (U ≲ X)
            -- → (U ≲ τ)
            → (x : U)
            → Σ[ B ∈ Type₀ ]
              Σ[ _ ∈ (B ∈s 𝐵) ]
              Σ[ B≲U ∈ B ≲ U ]
              Σ[ b ∈ B ]
              ((_≲_.to B≲U b) ≡ x)
              )
  → (∀ (V : Type₀)
     → (V ≲ X)
     -- → V ∈ τ
     → UnionTruncation V 𝐵
     → Σ[ J ∈ Type₀ ]
       (V ≃ (Union J 𝐵))
    )
prop232 X τ 𝐵 given₁ V V≲X unionTruncation
  = V
  , record
    { to = λ v → let ( Bₓ , B∈s𝐵 , B≲U , b , b→v ) = given₁ V V≲X v
                  in v , Bₓ , B∈s𝐵
    ; from = λ{ (x , Bₓ , Bₓ∈s𝐵) → x}
    ; from∘to = λ x → refl
    ; to∘from = λ y → unionTruncation
                         ( proj₁ y
                         , proj₁ (given₁ V V≲X (proj₁ y))
                         , proj₁ (proj₂ (given₁ V V≲X (proj₁ y))))
                         y
                         refl
    }
