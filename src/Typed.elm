module Typed exposing
    ( Typed
    , ReadOnly, ReadWrite
    , new
    , value, map, andThen
    , encode, decode
    )

{-|


# Types

@docs Typed


# Permissions

@docs ReadOnly, ReadWrite


# Constructor

@docs new


# Manipulation

@docs value, map, andThen


# Serialization

@docs encode, decode

-}

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)



-- Types


{-| A definition of `Typed` data.

Users can control data modifiability by giving permission to the type variable `p`.

-}
type Typed tag a p
    = Typed a



-- Permissions


{-| ReadWrite permission allows users to call all functions.
-}
type ReadWrite
    = ReadWrite


{-| ReadOnly permission prohibits users to call all functions that do constructing and updating such as `new`, `map` and `andThen`.
-}
type ReadOnly
    = ReadOnly



-- Constructor


{-| -}
new : a -> Typed tag a ReadWrite
new =
    Typed



-- Manipulation


{-| -}
value : Typed tag a p -> a
value (Typed value_) =
    value_


{-| -}
map : (a -> a) -> Typed tag a ReadWrite -> Typed tag a ReadWrite
map f (Typed value_) =
    Typed <| f value_


{-| -}
andThen : (a -> Typed tag b ReadWrite) -> Typed tag a ReadWrite -> Typed tag b ReadWrite
andThen f (Typed value_) =
    f value_



{- Serialization

   Regardless of the given permission, `decode` is always available to generate `Typed` data.

-}


{-| -}
encode : (a -> Value) -> Typed tag a p -> Value
encode encoder (Typed value_) =
    encoder value_


{-| -}
decode : Decoder a -> Decoder (Typed tag a p)
decode decoder =
    Json.Decode.map Typed decoder
