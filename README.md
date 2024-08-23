## What is the transport problem?
The transportation (distribution) problem or theory is a particular model of the linear programming problem. This type of problem is about finding a way to minimize the transport costs for the distribution of a given good from the points of supply, called sources, to the points of reception, called destinations. A particular case of the transport problem is the assignment problem, which consists of optimally distributing tasks to workers, and the transshipment problem, when goods can pass through intermediate receiving and shipping points, i.e. transit points, to reach their final destination.

In order to solve the transport problem with RStudio, the user has to write a few lines of code and already be familiar with the program, as well as have it installed on the computer. However, in most cases, people do not know the structure of the R language, or the RStudio program, but still need to solve a transport problem. For this purpose, and also to demonstrate the possibilities of the Shiny package, an application has been developed to solve this particular type of
statistical problem.

## Description of Shiny
The application [4] is composed of three pages: the main page (Figure 1), the guide (including instructions for the use of the application and a brief theoretical information of the transport problem), and, finally, the page with the general information of Shiny. In the main part, it can be seen that the need to work with the lines of code as such is eliminated, but the learner simply has to follow the following steps, which are also described in the second section of the application in the &quot;Guide&quot; part:
1. Select the number of rows (origins) and columns (destinations), using the corresponding buttons.
2. Select the type of problem to be solved with the &quot;Select problem type&quot; button.
3. Select whether it is a maximization or minimization problem.
4. Enter the transport cost matrix and the addresses of the constraints in the corresponding fields (Attention! To avoid malfunctioning of the program, it is mandatory to enter the addresses of the constraints as indicated in the application itself).
5. Click on the &quot;Solution&quot; button to obtain the result. In this way, the time and effort needed to solve this problem is reduced, which is demonstrated in the following section, solving the previous example, using this Shiny.
