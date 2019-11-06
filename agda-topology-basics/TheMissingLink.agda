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


postulate  -- Univalence axiom
  coe-equiv : ∀ {A B : Set} → A ≡ B → A ≃ B
  ua : ∀ {l} {A B : Set l} → (A ≃ B) → A ≡ B
  ua-η : {A B : Set} (p : A ≡ B) → ua (coe-equiv p) ≡ p

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
SetOfSubsets : Set → Set₁
SetOfSubsets X = (X → Set) → Set

-- How do we say that something is present in a given set of subsets?
--
-- Probably give back the predicate and show all elements satisfying
-- it are isomorphic to S?
--
_∈s_ : {X : Set} → (S : Set) → (SetOfSubsets X) → Set₁
_∈s_ {X} S ℙ =
  Σ[ P ∈ (X → Set) ]
  ( ∀ (x : X) → (P x ≃ S))

--
-- Type of a potentially infinite union of subsets of X indexed by
-- type J is a triple of index, type by that index (no proof of that),
-- and a proof that it's in the set of subsets
--
--
Union : {X : Set} → (J : Set) → (𝐵 : SetOfSubsets X) → Set₁
Union J 𝐵 = Σ[ j ∈ J ] Σ[ Bⱼ ∈ Set ] (Bⱼ ∈s 𝐵)

record UnionRec {X : Set} (J : Set) (𝐵 : SetOfSubsets X) : Set₁ where
  field
    getJ : J
    getBj : Set
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
       (V ≃ (Union J 𝐵))
    )
prop232 X τ 𝐵 given₁ V V≲X
  = V
  , record
    { to = λ v → let ( Bₓ , B∈s𝐵 , B≲U , b , b→v ) = given₁ V V≲X v
                  in v , Bₓ , B∈s𝐵
                  -- in {!b , ? , ?!}
                  -- in v , Bₓ , B∈s𝐵
    ; from = λ{ (x , Bₓ , Bₓ∈s𝐵) → x}
    ; from∘to = λ x → refl
    ; to∘from = λ{ (x , Bₓ , Bₓ∈s𝐵) → {! !}}
    -- prop232--to∘from -- λ{ (x , Bₓ , Bₓ∈s𝐵) → {!!}}
    }

-- Goal: (x , proj₁ (given₁ V V≲X x) , proj₁ (proj₂ (given₁ V V≲X x)))
--       ≡ (x , Bₓ , Bₓ∈s𝐵)

  where
    subg₁ : (V : Set) → (x : V) → (V≲X : V ≲ X)
      → (Bₓ : Set)
      → (Bₓ∈s𝐵  : Bₓ ∈s 𝐵)
      → proj₁ (given₁ V V≲X x) ≡ Bₓ
    subg₁ V x V≲X Bₓ Bₓ∈s𝐵 =
      ua (record
          { to = λ{proj₁_given₁_V_V≲X_x → {!!}}
          ; from = λ Bₓ₁ → {!Bₓ₁!}
          ; from∘to = {!!}
          ; to∘from = {!!}
          })

    -- prop232--to∘from--iso : (y : Union V 𝐵) →
    --   (((λ { (x , Bₓ , Bₓ∈s𝐵) → x }) y ,
    --    proj₁ (given₁ V V≲X ((λ { (x , Bₓ , Bₓ∈s𝐵) → x }) y)) ,
    --    proj₁ (proj₂ (given₁ V V≲X ((λ { (x , Bₓ , Bₓ∈s𝐵) → x }) y))))
    --    ≃ y)
    -- prop232--to∘from--iso = {!!}
    -- prop232--to∘from : (y : Union V 𝐵) →
    --   ((λ { (x , Bₓ , Bₓ∈s𝐵) → x }) y ,
    --    proj₁ (given₁ V V≲X ((λ { (x , Bₓ , Bₓ∈s𝐵) → x }) y)) ,
    --    proj₁ (proj₂ (given₁ V V≲X ((λ { (x , Bₓ , Bₓ∈s𝐵) → x }) y))))
    --   ≡ y
    -- prop232--to∘from y = {!ua (prop232--to∘from--iso y)!}
 
-- Goal: (x , proj₁ (given₁ V V≲X x) , proj₁ (proj₂ (given₁ V V≲X x)))
--       ≡ (x , Bₓ , Bₓ∈s𝐵)

-- prop232Rec
--   : (X : Set)
--   → (τ : SetOfSubsets X)
--   → (𝐵 : SetOfSubsets X)
--   → (given₁ : ∀ (U : Set)
--             → (U ≲ X)
--             -- → (U ≲ τ)
--             → (x : U)
--             → Σ[ B ∈ Set ]
--               Σ[ _ ∈ (B ∈s 𝐵) ]
--               Σ[ B≲U ∈ B ≲ U ]
--               Σ[ b ∈ B ]
--               ((_≲_.to B≲U b) ≡ x)
--               )
--   → (∀ (V : Set)
--      → (V ≲ X)
--      -- → V ∈ τ
--      → Σ[ J ∈ Set ]
--        (V ≃ (UnionRec J 𝐵))
--     )
-- prop232Rec X τ 𝐵 given₁ V V≲X
--   = V
--   , record
--     { to = λ v →
--            let ( Bₓ , B∈s𝐵 , p₂ , p₃ ) = given₁ V V≲X v
--            in
--              record
--                { getJ = v
--                ; getBj = Bₓ
--                ; getBjInB = B∈s𝐵
--                }
--     ; from = λ x → getJ x -- λ{ (x , Bₓ , Bₓ∈s𝐵) → x}
--     ; from∘to = λ x → refl
--     ; to∘from = prop232--to∘from -- λ{ (x , Bₓ , Bₓ∈s𝐵) → {!!}}
--     }
--   where
--     prop232--to∘from--iso : (y : UnionRec V 𝐵) →
--       record
--       { getJ = getJ y
--       ; getBj = proj₁ (given₁ V V≲X (getJ y))
--       ; getBjInB = proj₁ (proj₂ (given₁ V V≲X (getJ y)))
--       }
--       ≃ y
--     prop232--to∘from--iso = {!!}
--     prop232--to∘from : (y : UnionRec V 𝐵) →
--       record
--       { getJ = getJ y
--       ; getBj = proj₁ (given₁ V V≲X (getJ y))
--       ; getBjInB = proj₁ (proj₂ (given₁ V V≲X (getJ y)))
--       }
--       ≡ y
--     prop232--to∘from = {!!}
