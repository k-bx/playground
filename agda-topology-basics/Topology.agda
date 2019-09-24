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

allSubsets : Set → Set₁
allSubsets X =
  Σ[ P ∈ (X → Set) ]
  Σ[ a ∈ X ]
  (P a)

isTopology : Set → Set₁
isTopology X =
  Σ[ τ ∈ (allSubsets X → Set) ]
  Σ[ s ∈ allSubsets X ]
  {!!}
