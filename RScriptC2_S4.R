#Starting to talk about lists now! Yay! I can somewhat understand this!

#This is an example of a list
x <- list(1, 2, 3)
x
str(x)

#You can also name the values in a list
x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

#Lists can actually store different values, while vectors just shift them to a string or a double or w/e
y <- list("a", 1L, 1.5, TRUE)
str(y)
str(c("a", 1L, 1.5, TRUE))

#Lists also contain other lists
z <- list(list(1, 2), list(3, 4))
str(z)

#This is just an example of list hierarchies
x1 <- list(c(1, 2), c(3, 4))
x2 <- list(list(1, 2), list(3, 4))
x3 <- list(1, list(2, list(3)))
#x1 looks like this:
#[(1, 2), (3, 4)]
#x2 looks like this:
#[[1, 2], [3, 4]]
#x3 looks like this:
#[1, [2, [3]]]

#This is how you subset a list
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5)) #makes a list containing: a range from 1-3, "a string", pi, and a new list
str(a[1:2]) #Shows the rows of list a from 1 to 2
str(a[4]) #Shows row 4 of list a

#Gets the actual item instead of the item inside the list
str(a[[1]])
str(a[[4]])

#You can also access named elements of a list by using $ or [[]]
a$a
a[["a"]]