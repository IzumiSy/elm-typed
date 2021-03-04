module Typed exposing
    ( Typed
    , ReadOnly, ReadWrite, WriteOnly
    , new, inunwrappable
    , value, map, andThen
    , encode, decode, encodeStrict, decodeStrict
    )

{-|


# Types

@docs Typed


# Permissions

@docs ReadOnly, ReadWrite, WriteOnly


# Constructor

@docs new, inunwrappable


# Manipulation

@docs value, map, andThen


# Serialization

@docs encode, decode, encodeStrict, decodeStrict

-}

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)



-- Types


{-| A definition of `Typed` data.

Users can control data modifiability by giving permission to the type variable `p`.

-}
type Typed tag a p
    = Typed a


type Allowed
    = Allowed


type Unallowed
    = Unallowed


type alias Readable p =
    { p | read : Allowed }


type alias Writable p =
    { p | write : Allowed }



-- Permissions


{-| ReadWrite permission allows users to call all functions.
-}
type alias ReadWrite =
    { read : Allowed
    , write : Allowed
    , unwrap : Allowed
    }


{-| ReadOnly permission prohibits users to call all functions that do constructing and updating such as `new`, `map` and `andThen`.
-}
type alias ReadOnly =
    { read : Allowed
    , write : Unallowed
    }


{-| Inunwrappable permission prohibits users to call `value` function to get internal implementation.
-}
type alias WriteOnly =
    { read : Unallowed
    , write : Allowed
    }



-- Constructor


{-| -}
new : a -> Typed tag a ReadWrite
new =
    Typed


{-| -}
inunwrappable : a -> Typed tag a WriteOnly
inunwrappable =
    Typed



-- Manipulation


{-| -}
value : Typed tag a (Readable p) -> a
value (Typed value_) =
    value_


{-| -}
map : (a -> a) -> Typed tag a (Writable p) -> Typed tag a (Writable p)
map f (Typed value_) =
    Typed <| f value_


{-| -}
andThen : (a -> Typed tag b (Writable p)) -> Typed tag a (Writable p) -> Typed tag b (Writable p)
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


{-| Stricter version of `encode` that accepts a tag to check.
-}
encodeStrict : tag -> (a -> Value) -> Typed tag a p -> Value
encodeStrict _ =
    encode


{-| Stricter version of `decode` that accepts a tag to check.
-}
decodeStrict : tag -> Decoder a -> Decoder (Typed tag a p)
decodeStrict _ =
    decode
