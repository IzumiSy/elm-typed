# elm-typed

> Type-safe way aliasing your primitive types easily

This, elm-typed, is a package that helps developers to achieve additional type-safety without opaque modules.

## Example
Fundamental concept is the same as the packages mentioned at "Prior art" section of this document have.

The core feature this package offers in addition is permission. Users can control modifiability on the type defition.

```elm
import Typed exposing (Typed, ReadOnly, ReadWrite)


type MemberIdType
    = MemberIdType

type alias MemberId
    = Typed MemberIdType String ReadOnly

type AgeType
    = AgeType

type alias Age
    = Typed AgeType Int ReadWrite

type alias Model =
    { memberId : MemberId
    , age : Age
    }
```

In the example, `memberId` cannot be reassign anymore because it is marked as `ReadOnly`. It cannnot be initialized or updated if `ReadOnly` permission given.

```elm
newMemberId : MemberId
newMemberId =
    Typed.new "1" -- compile error!

newAge : Age
newAge =
    Typed.new 30 -- ok
```

However, `MemberId` data can be initialized by decoding data coming from external resources, because `ReadOnly` permission only limits modification in your Elm application.

## Usecase: Entity and ValueObject
Entity and ValueObject are the concept coming from DDD (Domain Driven Design). The concept says that all application have some resources that are modifiable, and some not.
Modifiability is related to predictability, so marking every resource as modifiable or unmodifiable with its type definition lets developers know potential modification of resources in other place.
Unintended changes that produces bugs are usually made by mistake because of bad predictability.

In order to design your application under this principle, we can craft Entity and ValueObject with this package.

WIP: code example will come here.

## License
MIT

## Contribution
PRs accepted

## Prior art
- [Punie/elm-id](https://package.elm-lang.org/packages/Punie/elm-id/latest/)
- [joneshf/elm-tagged](https://package.elm-lang.org/packages/joneshf/elm-tagged/latest/)
