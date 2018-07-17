import java.util.Random;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Arrays;

Random randy = new Random();

ArrayList<Individual> individuals;
ArrayList<Individual> nextIndividuals;

int numIndividuals = 10;
float mutationRate = 0.01;  //  percent mutation rate

int numGenerations = 0;
float averageFitness = 0;

PImage target;
int greaterTargetDimension;

Individual fittestIndividual;
Boolean perfectionAchieved = false;

float averageOffspring = 0;
float fittestIndividualOffspring = 0;

int targetDisplayWidth = 50;
int targetDisplayHeight = 50;

double generationStartTime = 0;
double generationEndTime = 0;
double generationDuration = 0;

Boolean showPopulationSample = true;
Boolean showFittestIndividual = true;
Boolean headlessMode = false;

public void setup()
{
  target = loadImage( "duccsmall.jpg" );

  //  determine greater targetDimension
  if( target.height > target.width )
  {
    greaterTargetDimension = target.height;
  }
  else
  {
    greaterTargetDimension = target.width;
  }
  
  individuals = new ArrayList<Individual>();

  for( int i = 0; i < numIndividuals; i++ )
  {
    Individual newIndividual = new Individual();
    individuals.add( newIndividual );
  }
  
  //size( 1500, 900 );
  fullScreen( P2D, 2 );
  frameRate( 1000 );
}

public void draw()
{
  delay( 10 );
  
  if (keyPressed) {
    if (key == 'q' || key == 'Q') 
    {
      mutationRate = mutationRate * 1.5;
    }
    else if (key == 'a' || key == 'A') 
    {
      mutationRate = mutationRate * 0.5;
    }
    else if (key == 's' || key == 'S') 
    {
      showPopulationSample =  !showPopulationSample;
    }
    else if (key == 'f' || key == 'F') 
    {
      showFittestIndividual = !showFittestIndividual;
    }
    else if (key == 'h' || key == 'H') 
    {
      headlessMode = !headlessMode;
    }
  }
  
  if( perfectionAchieved == false )
  {
    generationStartTime = millis();
    
    for( Individual individual : individuals )
    {
      individual.generatePhenotype();
      individual.calculateFitness();
    }
    calculateAverageFitness();

    fittestIndividual = findFittestIndividual();
    displayInfo();
    
    //  determine if perfection has been achieved
    //testForPerfection();
    
    breedNewGeneration();
    numGenerations++;
    
    //  mutate new generation
    for( Individual individual : nextIndividuals )
    {
      individual.mutate();
    }
    
    //  swap generation frames
    individuals = nextIndividuals;  
    
    generationEndTime = millis();
    generationDuration = generationEndTime - generationStartTime;
  }

}

public void testForPerfection()
{
  if( fittestIndividual.fitness >= 0.3 )
  {
    perfectionAchieved = true;
  }
}


public void breedNewGeneration()
{
  nextIndividuals = new ArrayList<Individual>();
  ArrayList<Individual> matingPool = new ArrayList<Individual>();
  
  //for( int i = 0; i < individuals.size(); i++ )
  //{
  //  float relativeFitness = map( individuals.get(i).fitness, averageFitness, fittestIndividual.fitness, 0.0, 1.0 );
  //  int ticketsInHat = (int)relativeFitness * 10;
  //  if( individuals.get(i) == fittestIndividual )
  //  {
  //    fittestIndividualOffspring = ticketsInHat;
  //  }
  //  for( int j = 0; j < ticketsInHat; j++ )
  //  {
  //    matingPool.add( individuals.get(i) );
  //  }
  //}
  
  for( int i = 0; i < 10; i++ )
  {
    matingPool.add( fittestIndividual );
  }
  fittestIndividualOffspring = 10;
  
  
  if( matingPool.size() < 1 )
  {
    matingPool = individuals;
  }
  for( int i = 0; i < individuals.size(); i++ )
  {
    int mateOneIndex = randy.nextInt( matingPool.size() );
    int mateTwoIndex = randy.nextInt( matingPool.size() );
    
    Individual mateOne = matingPool.get( mateOneIndex );
    Individual mateTwo = matingPool.get( mateTwoIndex );
    
    Individual offspring = mateOne.breed( mateTwo );
    nextIndividuals.add( offspring );
  }
  averageOffspring = matingPool.size() / individuals.size();
}

public void calculateAverageFitness()
{
  float totalFitness = 0;
  float numIndividuals = individuals.size();
  for( Individual individual : individuals )
  {
    totalFitness += individual.fitness;
  }
  
  averageFitness = totalFitness / numIndividuals;
}

public void displayInfo()
{ 
  //  print visuals
  background( 255, 255, 255 );
  fill( 0 );
  textSize( 32 );
 
  int drawHeight = 50;
  
  if( headlessMode == false )
  {
      //  //  print target
    text( "Target: ", 50, drawHeight );
    drawHeight += 32;
    image( target, 50, drawHeight, targetDisplayWidth, targetDisplayHeight );
    drawHeight += targetDisplayHeight + 50;
  
    //  //  print top individual
    text( "Top Individual: ", 50, drawHeight );
    drawHeight += 32;
    image( fittestIndividual.drawPhenotype( targetDisplayWidth, targetDisplayHeight ), 50, drawHeight, targetDisplayWidth, targetDisplayHeight );
    drawHeight += targetDisplayHeight * 2 + 30;
    
  }
  
  textSize( 18 );
  
  //  //  print target dimensions
  text( "Target Dimensions: " + "( " + target.width + ", " + target.height + " )", 50, drawHeight );
  drawHeight += 20;
  
  //  //  print generation number
  text( "Generation: " + String.valueOf(numGenerations), 50, drawHeight  );
  drawHeight += 20;
  
  //  //  print generation duration
  text( "Generation Duration: " + generationDuration, 50, drawHeight );
  drawHeight += 20;
  
  //  //  print average fitness
  text( "Average Fitness: " + String.valueOf( averageFitness ), 50, drawHeight );
  drawHeight += 20;
  
  //  //  print fitness of top individual
  text( "Top Individual Fitness: " + String.valueOf( fittestIndividual.fitness ), 50, drawHeight );
  drawHeight += 20;
  
  //  //  print fitness of top individual in percentage
  text( "Top Individual Fitness in Percentage: " + String.valueOf( fittestIndividual.fitness / ( ( 255 * 3 ) * target.pixels.length) * 100 ) + "%", 50, drawHeight );
  drawHeight += 20;
  
  //  //  print average number of offspring
  text( "Average #offspring: " + String.valueOf( averageOffspring ), 50, drawHeight );
  drawHeight += 20;
  
  //  //  print number of offspring fittest individual had
  text( "Fittest Individual #offspring: " + String.valueOf( fittestIndividualOffspring ), 50, drawHeight );
  drawHeight += 20;
  
  //  //  print mutation rate
  text( "Mutation Rate: " + String.valueOf( mutationRate * 100.0 ) + "%", 50, drawHeight );
  drawHeight += 20;
  
  if( headlessMode == true )
  {
    //  //  headlessMode warning
    text( "!HEADLESS MODE ACTIVE!: hold h through generation to deactivate", 50, drawHeight );
    drawHeight += 20;
  }
  
  //  //  print like 5ish individuals
  if( headlessMode == false )
  {
    if( showPopulationSample == true )
    {
      textSize( 15 );
      int listX = 1200;
      int listY = 50;
      for( int i = 0; i < 5; i++ )
      {
        Individual individualToDraw = individuals.get(i);
        image( individualToDraw.drawPhenotype( targetDisplayWidth, targetDisplayHeight ), listX, listY + i * ( targetDisplayHeight + 10), targetDisplayWidth, targetDisplayHeight );
      }
    }
    
    if( showFittestIndividual == true )
    {
      PGraphics fittestIndividualPhenotype = fittestIndividual.drawPhenotype( 500, 500 );
      image( fittestIndividualPhenotype, 500, 300 );  
    }
  }
}

public Individual findFittestIndividual()
{
  int bestIndividualIndex = 0;  
  float bestFitness = 0;
  for( int i = 0; i < individuals.size(); i++ )
  {
    if( individuals.get(i).fitness > bestFitness )
    {
      bestIndividualIndex = i;
      bestFitness = individuals.get( bestIndividualIndex ).fitness;
    }
  }
  
  return individuals.get( bestIndividualIndex );
}

public float clamp( float number, float lowerBounds, float upperBounds )
{
  if( number < lowerBounds )
  {
    return lowerBounds;
  }
  else if( number > upperBounds )
  {
    return upperBounds;
  }
  else
  {
    return number;
  }
}

float mapLog(float value, float start1, float stop1, float start2, float stop2) {
  start2 = log(start2);
  stop2 = log(stop2);
 
  float outgoing =
    exp(start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1)));
 
  String badness = null;
  if (outgoing != outgoing) {
    badness = "NaN (not a number)";
 
  } else if (outgoing == Float.NEGATIVE_INFINITY ||
             outgoing == Float.POSITIVE_INFINITY) {
    badness = "infinity";
  }
  if (badness != null) {
    final String msg =
      String.format("map(%s, %s, %s, %s, %s) called, which returns %s",
                    nf(value), nf(start1), nf(stop1),
                    nf(start2), nf(stop2), badness);
    PGraphics.showWarning(msg);
  }
  return outgoing;
}