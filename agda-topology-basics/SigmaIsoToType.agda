import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; cong-app)
open Eq.≡-Reasoning
open import Data.Product public using (Σ; Σ-syntax; _×_; _,_; proj₁; proj₂; map₁; map₂)

infix 0 _≃_
record _≃_ (A B : Set) : Set where
  field
    to   : A → B
    from : B → A
    from∘to : ∀ (x : A) → from (to x) ≡ x
    to∘from : ∀ (y : B) → to (from y) ≡ y
open _≃_

-- let's show that 2*2 == 2*2

data Bool : Set where
  True : Bool
  False : Bool

twotwo : ( ( Bool × Bool ) ≃ ( Bool × Bool ) )
twotwo =
  record
    { to = λ x → proj₁ x , proj₂ x
    ; from = λ x → x
    ; from∘to = λ x → refl
    ; to∘from = λ y → refl
    }

-- now similarly with sigma

twotwo₂ : ( ( Bool × Bool ) ≃ Σ[ b ∈ Bool ] Bool )
twotwo₂ =
  record
    { to = λ x → proj₁ x , proj₂ x
    ; from = λ x → x
    ; from∘to = λ x → refl
    ; to∘from = λ y → refl
    }

-- -- let's show that a sigma is isomorphic to Pi(Bool)

-- sigma_iso_to_pi : (∀ (b : Bool) → ) ≃
