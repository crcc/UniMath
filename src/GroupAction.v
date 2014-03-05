(** * Group actions *)

Unset Automatic Introduction.
Require Import Foundations.hlevel2.algebra1b.
Require Foundations.Proof_of_Extensionality.funextfun.
Require RezkCompletion.pathnotations.
Import pathnotations.PathNotations. 
Require Import Ktheory.Utilities.
Require RezkCompletion.precategories.
Import Utilities.Notation.

Record type (G:gr) :=
  make {
      act_set :> hSet;
      act_mult (g:G) : act_set -> act_set;
      act_unit : forall x, act_mult (unel _) x == x;
      act_assoc : forall g h x, act_mult (op g h) x == act_mult g (act_mult h x)
    }.
Arguments act_set {G} _.
Arguments act_mult {G} {_} g x.

Local Notation action := type.

Definition is_equivariant {G:gr} {X Y:action G} (f:X->Y) :=
  forall g x, act_mult g (f x) == f (act_mult g x).

Definition equivariant_map {G:gr} (X Y:action G) := total2 (@is_equivariant _ X Y).

Definition mult_map {G:gr} {X:action G} (x:X) := fun g => act_mult g x.

Definition is_torsor (G:gr) (X:action G) := 
  dirprod (ishinh X) (forall x:X, isweq (mult_map x)).

Definition Torsor (G:gr) := total2 (is_torsor G).
Definition underlying_action {G:gr} (X:Torsor G) := pr1 X.
Coercion underlying_action : Torsor >-> action.

Definition trivialTorsor (G:gr) : Torsor G.
Proof. 
  intros. exists (make G G op (lunax G) (assocax G)).
  exact (hinhpr _ (unel G),, 
         fun x => precategories.iso_set_isweq 
           (fun g => op g x) 
           (fun g => op g (grinv _ x))
           (fun g => assocax _ g x (grinv _ x) @ ap (op g) (grrinvax G x) @ runax _ g)
           (fun g => assocax _ g (grinv _ x) x @ ap (op g) (grlinvax G x) @ runax _ g)).
Defined.

Definition univ_function {G:gr} (X:Torsor G) (x:X) : trivialTorsor G -> X.
Proof. intros ? ? ?. apply mult_map. assumption. Defined.

Definition univ_map {G:gr} (X:Torsor G) (x:X) : equivariant_map (trivialTorsor G) X.
Proof. intros ? ? ?. exists (univ_function X x).
       intros g h. apply pathsinv0. apply act_assoc. Defined.

Definition triviality_isomorphism {G:gr} (X:Torsor G) (x:X) :
  weq (trivialTorsor G) X.
Proof. intros. exists (univ_function X x). apply (pr2 (pr2 X)). Defined.

Definition A {X Y:hSet} (f:pr1hSet X==pr1hSet Y) : X==Y.
Proof. intros [X i] [Y j] e.
       apply (pair_path e (pr1 (isapropisaset Y (e#i) j))). Defined.       

Definition B {G:gr} {X Y:action G} 
           (f:act_set X->act_set Y)
           (is:isweq f)
           (ie:is_equivariant f) : 
  X == Y.
Proof. intros.
       destruct X as [Xs Xm Xu Xa].
       destruct Y as [Ys Ym Yu Ya].
       simpl in f.
       set (e := funextfun.weqtopaths0 _ _ (weqpair f is)).
admit.
Defined.

Lemma is_connected_classifying_space (G:gr) : isconnected(Torsor G).
Proof.                          (* this uses univalence *)
  intros ?. apply (base_connected (trivialTorsor _)).
  intros X. apply (squash_to_prop (pr1 (pr2 X))). 
  { apply pr2. }
  { intros x. apply hinhpr. assert (q : pr1(trivialTorsor G) == pr1 X).
    { assert (r : act_set(pr1(trivialTorsor G)) == act_set(pr1 X)).
      { apply A. apply funextfun.weqtopaths0. 
        apply triviality_isomorphism. exact x. }
      admit. }
    { admit. } } Defined.
