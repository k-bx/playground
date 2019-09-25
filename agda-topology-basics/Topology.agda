module Topology where

open import Data.Product public using (Σ; Σ-syntax; _×_; _,_; proj₁; proj₂; map₁; map₂)

-- Goal: encode the notion of Topology:
--
-- Let X be a non-empty set. A set τ of subsets of X
-- is said to be a topolgy on X if:
-- 
-- 1. X and the empty set, Ø, belong to τ
-- 2. The union of any (finite or infinite) number of sets
-- in τ belongs to τ
-- 3. The intersection of any two sets in τ belongs to τ
--
-- The pair (X,τ) is called a topological space.

-- We can express a notion of a subset `{ x : A | P(x) }` 
-- as `Σ[ x ∈ A ] (P x)` (with notion that P is mere 
-- proposition in mind).

-- So first, a set of all subsets of a type is:

data Ø : Set where

data P₀ : Set → Set where

-- subset : (X : Set) → (X → Set) → Set₁
-- subset X P = Σ[ a ∈ X ] (P a)

subset : Set → Set₁
subset X =
  ∀ (P : (X → Set)) →
  Σ[ a ∈ X ]
  (P a)

subset′ : (X : Set) → (P : (X → Set)) → Set
subset′ X P =
  Σ[ a ∈ X ] (P a)

-- TODO: think again why one is Set₁ and another is Set

allSubsets : Set → Set₁
allSubsets X =
  Σ[ P ∈ (X → Set) ]
  Σ[ a ∈ X ]
  (P a)

allSubsets′ : Set → Set₁
allSubsets′ X =
  Σ[ P ∈ (X → Set) ]
  subset′ X P

-- If subset is described by a predicate that's describing an 
-- inhabited proposition for every element in X, a set of all 
-- subsets must describe a predicate that's describing an
-- inhabited proposition for every **predicate** on X
allSubsets′′ : (X : Set) → (ℙ : (X → Set) → Set) → Set₁
allSubsets′′ X ℙ =
  Σ[ P ∈ (X → Set) ]
  (ℙ P)

-- X-∈-allSubsets-X :
--   (X : Set)
--   → (S : Σ[ P ∈ (X → Set) ] Σ[ a ∈ X ] (P a))
--   → (Q : ((Σ[ P ∈ (X → Set) ] Σ[ a ∈ X ] (P a)) → Set))
--   → (Q X)
-- X-∈-allSubsets-X = ?

-- isTopology : Set → Set₁
-- isTopology X =
--   Σ[ τ ∈ (allSubsets X → Set) ]
--   Σ[ s ∈ allSubsets X ]
--   {!!}

-- TODO: how do we claim that `Ø ∈ (allSubsets X)` ?
-- TODO: how do we claim that `X ∈ (allSubsets X)` ?

isTopology-alt : (X : Set) → (τ : allSubsets′ X → Set) → Set
isTopology-alt X τ =
  Σ[ _ ∈ τ ((λ _ → X) , {!!} , {!!}) ]
  {!!}
