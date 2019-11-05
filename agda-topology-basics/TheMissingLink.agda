import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; cong-app)
open Eq.≡-Reasoning
open import Data.Product public using (Σ; Σ-syntax; _×_; _,_; proj₁; proj₂; map₁; map₂)
open import Data.Sum
open import Level

infix 0 _≃_
record _≃_ {l m} (A : Set l) (B : Set m) : Set (l ⊔ m) where
  field
    to   : A → B
    from : B → A
    from∘to : ∀ (x : A) → from (to x) ≡ x
    to∘from : ∀ (y : B) → to (from y) ≡ y
open _≃_

infix 0 _≲_
record _≲_ (A B : Set) : Set where
  field
    to      : A → B
    from    : B → A
    from∘to : ∀ (x : A) → from (to x) ≡ x
open _≲_

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

SetOfSubsets : Set → Set₁
SetOfSubsets X = (X → Set) → Set

-- How do we say that something is present in a given set of subsets?
--
-- Probably give back the predicate and show all elements satisfying
-- it are isomorphic to S?
_∈s_ : {X : Set} → (S : Set) → (SetOfSubsets X) → Set₁
_∈s_ {X} S ℙ =
  Σ[ P ∈ (X → Set) ]
  ( ∀ (x : X) → (P x ≃ S))

Union : (X : Set) → (J : Set) → (𝐵 : SetOfSubsets X) → Set₁
Union X J 𝐵 = Σ[ j ∈ J ] Σ[ Bⱼ ∈ Set ] (Bⱼ ∈s 𝐵)

-- "Topology without tears" 2.3.2 constructively
--
-- 2.3.2 Let (X, τ) be a topological space. A family B of open subsets
-- of X is a basis for τ if and only if for any point x belonging to
-- any open set U , there is a B ∈ B such that x ∈ B ⊆ U.
--
--
prop232
  : (X : Set)
  → (τ : SetOfSubsets X)
  → (𝐵 : SetOfSubsets X)
  → (given₁ : ∀ (U : Set)
            → (U ≲ X)
            -- → (U ≲ τ)
            → (x : U)
            → Σ[ B ∈ Set ]
              Σ[ _ ∈ (B ∈s 𝐵) ]
              Σ[ B≲U ∈ B ≲ U ]
              Σ[ b ∈ B ]
              ((_≲_.to B≲U b) ≡ x)
              )
  → (∀ (V : Set)
     → (V ≲ X)
     -- → V ∈ τ
     → Σ[ J ∈ Set ]
       (V ≃ (Union X J 𝐵))
    )
prop232 = {!!}
