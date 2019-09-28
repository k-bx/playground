module Topology where

open import Data.Product public using (Σ; Σ-syntax; _×_; _,_; proj₁; proj₂; map₁; map₂)
open import Data.Sum

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

subset : (X : Set) → (P : (X → Set)) → Set
subset X P =
  Σ[ a ∈ X ] (P a)

-- If subset is described by a predicate that's describing an
-- inhabited proposition for every **element** in X, a set of subsets
-- must describe a predicate that's describing an inhabited
-- proposition for every **predicate** on X
setOfSubsets : (X : Set) → (ℙ : (X → Set) → Set) → Set₁
setOfSubsets X ℙ =
  Σ[ P ∈ (X → Set) ]
  (ℙ P)

data Ø : Set where
data ⊤ : Set where
  ⋆ : ⊤


-- Identity predicate
P-id : {X : Set} → (X → Set)
P-id = λ{_ → ⊤}

-- Zero predicate
P₀ : {X : Set} → (X → Set)
P₀ = λ{_ → Ø}

-- Union of subsets

SubsetUnion : {X : Set}
  → (A : X → Set)
  → (B : X → Set)
  → Set₁
SubsetUnion {X} A B = {!!}

isTopology : (X : Set) → (τ : (X → Set) → Set) → Set₁
isTopology X τ =
  Σ[ P ∈ (X → Set) ]
  Σ[ _ ∈ τ P ]
  Σ[ _ ∈ τ P-id ]
  Σ[ _ ∈ τ P₀ ]
  (∀ (A B : X → Set) → (u : SubsetUnion A B) → (τ A) → (τ B) → (τ u))  -- TODO: union of any number of sets in τ belongs to τ

--
-- Please do not read below this line (a.k.a. Here Be Dragons...)
--

subset′ : Set → Set₁
subset′ X =
  ∀ (P : (X → Set)) →
  Σ[ a ∈ X ]
  (P a)

-- TODO: think again why one is Set₁ and another is Set

allSubsets : Set → Set₁
allSubsets X =
  Σ[ P ∈ (X → Set) ]
  Σ[ a ∈ X ]
  (P a)

allSubsets′ : Set → Set₁
allSubsets′ X =
  Σ[ P ∈ (X → Set) ]
  subset X P

-- X-∈-allSubsets-X :
--   (X : Set)
--   → (ℙ : (X → Set) → Set)
--   → (S : allSubsets′′ X)
--   → (Q : ((Σ[ P ∈ (X → Set) ] Σ[ a ∈ X ] (P a)) → Set))
--   → (Q X)
-- X-∈-allSubsets-X = ?

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

-- isTopology-alt : (X : Set) → (τ : allSubsets′ X → Set) → Set
-- isTopology-alt X τ =
--   Σ[ _ ∈ τ ((λ _ → X) , {!!} , {!!}) ]
--   {!!}
