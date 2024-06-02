# How to elegantly create diagram - Penrose

## Why do you need Penrose?

It is extremely difficult to create mathematical diagram when specifying effectiveness and glamours. For most of the time we focus on the relationship such as A set is disjoint form B set, but we don’t really care about the relative distance between the sets and size for each one. Traditional tools such as photoshop or blender, C4D are much too heavy and lack the support to math notions. For most of the computer graphics tool such as those build upon OpenGL, you have to spend a lot of time on adjusting cameras and canvas and importing models. Also, when creating slides and papers, you must have been dealt with the incompatibility between pictures format and size and the arrangement of pictures and texts. I have always been amazed by Keenan Crane’s wonderful diagrams on his slides and confused about how he creates them. Such diagrams include 2D curves, 3D surfaces, abstract diagrams and so on. All the diagrams follows a consistent ascetic and conveys clear math notations with some randomness, as we claimed, the explicit size will only bother us with endless adjustments. I wasn't able to figure out how he created those diagrams until I found Penrose. Penrose is open source diagram generators written in typescript maintain by CMU CS team. No surprise that Prof Keenan is one of the advisor of this project. Penrose provides a declarative DSL to specify all the relationships and math notations. With given input, Penrose would provide with a bunch of diagrams satisfying the input but with randomness. Also the output is an editable svg, and also vectorize. From here I will provide a simple tutorial.

## Simple example

I would only recommend you editing online since running the repo locally is counter intuitive. Plus the online editor support bug reports and basic auto completion. But you can integrate Penrose as a JS library into your webpage or simply use as a render. Such setup is listed [here](https://penrose.cs.cmu.edu/docs/ref/vanilla-js). Penrose also provides a CLI can be found [here](https://penrose.cs.cmu.edu/docs/ref/using#command-line-interface-roger).

Penrose includes three files:

- .domain: declare the type, just like a type interface.
- .style: defines all the relations explicitly.
- .substance: declare the explicit object following the type from .domain.

Consider the whole system as a mathematical set. .domain is set space, .substance is the element in the set.  .style is group actions towards the set(element).

*For every edit you make, you need to press compile button to apply.*

A typical .domain includes *type* and *predicate*

```js
--.domain

type Set

predicate Disjoint(Set s1, Set s2)
predicate Intersecting(Set s1, Set s2)
predicate Subset(Set s1, Set s2)
```

*Set* is the interface we want to use, defined with keyword *type*. *predicate* defines some rules we want we will implement  and use later. The rules simples serves as functions, you give some input parameters, the function helps you to achieve some effects. Notice that here all the name of such rule is capital to distinguish from the pre-defined prediactes from Penrose. Such predicates are the basic operation can be combined inside the implementation  of rule. You can define any name you for example you can change Disjoint into

```
predicate xxxx(Set s1, Set s2) 
predicate Disdasdnksjoint(Set s1, Set s2)
```

Considering the rules we want to use here is the same as those pre-defined predcapitalisedicates, so we just use the same name. Again the user defined name is capitalised, the Penrose defined are all lowercase, we will use them in .style. The list of pre-defined prediactes can be found [here](https://penrose.cs.cmu.edu/docs/ref/style/functions#constraint-functions). You can add comment to any line with two dashes at the very beginning. The shortcut is traditional command/ctrl + /.

After we have the interface, we can declare the objects in .substance

```
--.substance

Set A, B, C, D, E, F, G

Subset(B, A)
Subset(C, A)
Subset(D, B)
Subset(E, B)
Subset(F, C)
Subset(G, C)

Disjoint(E, D)
Disjoint(F, G)
Disjoint(B, C)

AutoLabel All
```

The first line a traditional definition just like python or C. The keyword *Subset* and *Disjoint* indicates the math relation between some variables defined above. Those keywords are from the predicates included in .domain. The last line means we add a label/notation to all the objects we defined. You will see marks of their name in the diagram.

Most of the work in Penrose lies in .style.

```
--.style

canvas {
  width = 800
  height = 700
}

forall Set x {
  shape x.icon = Circle { }
  shape x.text = Equation {
    string : x.label
    fontSize : "32px"
  }
  ensure contains(x.icon, x.text)
  encourage norm(x.text.center - x.icon.center) == 0
  layer x.text above x.icon
}

forall Set x; Set y
where Subset(x, y) {
  ensure disjoint(y.text, x.icon, 10)
  ensure contains(y.icon, x.icon, 5)
  layer x.icon above y.icon
}

forall Set x; Set y
where Disjoint(x, y) {
  ensure disjoint(x.icon, y.icon)
}

forall Set x; Set y
where Intersecting(x, y) {
  ensure overlapping(x.icon, y.icon)
  ensure disjoint(y.text, x.icon)
  ensure disjoint(x.text, y.icon)
}
```

The first block is always some declarations for the canvas. Besides width and height there are many more properties such as color and transparency. For the remaining blocks we first take a look about the definition of each block. You will find this is similar to the logic of simple sql query.

```
forall x ; y 
where (conditions x y){}
```

And again the conditions are from the rules defined in .domain.

We want to define some styles for all the instances on the screen. Thats what happened in the first block. *ensure* and *encourage* are both some constraints we inform Penrose. The difference is *ensure* is something Penrose must satisfy, while *encourage* is something Penrose has right to decline but still priorities. In the above example you can explain as the shape must have a notation inside and we want the notation aligns with the center of the shape. But this may fail due to the size/pixels of other constraints. *above* defines the layer between each components. You can choose text to be *above* or *below* the shape. The transparency of the text will change as you modify.

Each of the following blocks are the implementation to the rule we wrote in .domain. We use *ensure* the bridge between the user-defined function and the pre-defined predicates.

Put all the codes together we would receive such picture. Your output could be different from mine since randomness.



The Set relation is preserved, each set has its notation. If you don’t like the color or arrangement, you can add more constraints or simply click the resample button.  This is great! By default Penrose would export Pensore svg, which is just a simple svg followed by all the code you wrote above. You can consider this svg as a project so that you can upload it to the website and continue your work somewhere else. You can use a text editor to open the Pensore svg.

## Extras

Another thing about predefined predicates is some of them allow extra parameters. For example we can create a classic set diagram use to introduce union, intersection and complement.

```
.domain

type Set
predicate Intersecting(Set A, Set B)

.substance
Set A, B
Intersecting(A, B)
AutoLabel All

.style
canvas {
  width = 800
  height = 700
}

forall Set x {
    x.icon = Circle {
        strokeWidth : 0.0
    }
    ensure x.icon.r > 25
    ensure x.icon.r < 150
}

forall Set x; Set y
where Intersecting(x, y) {
    ensure overlapping(x.icon, y.icon, -15)
}
```

After some resample you can choose one you like.



## Advanced
