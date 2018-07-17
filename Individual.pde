public class Individual implements Breedable, Comparable<Individual>
{
  final static int NUM_POLYGONS = 50;
  final static int NUM_POINTS_PER_POLYGON = 6;
  final static int GENES_PER_POLYGON = (2 + 3 + 1) * NUM_POINTS_PER_POLYGON;
  final static int NUM_GENES = NUM_POLYGONS * GENES_PER_POLYGON;
  
  DNA genotype;
  PGraphics phenotype;
  float fitness;
  
  public Individual()
  {
    genotype = new DNA();
    phenotype = createGraphics( target.width, target.height );
  }

  //  non default alternate constructor
  public Individual( DNA genes )
  {
    this.genotype = genes;
  }
  
  @Override
  public Individual breed( Individual mate )
  {
    DNA offspringGenotype = new DNA();
    int splicePoint = randy.nextInt( genotype.genes.length );   
    for( int i = 0; i < genotype.genes.length; i++ )
    {
      if( i < splicePoint )
      {
        offspringGenotype.genes[i] = genotype.genes[i]; 
      }
      else
      {
        offspringGenotype.genes[i] = mate.genotype.genes[i]; 
      }
    }
    
    Individual offspring = new Individual( offspringGenotype );
    return( offspring );
  }
  
  public void mutate()
  {
    for( int i = 0; i < genotype.genes.length; i++ )
    {
      if( randy.nextFloat() < mutationRate )
      {
        genotype.mutate();
      }
    }
  }
  
  public void generatePhenotype()
  {
    phenotype = drawPhenotype( target.width, target.height );
  }
  
  public PGraphics drawPhenotype( int renderWidth, int renderHeight )
  {
    PGraphics render = createGraphics( renderWidth, renderHeight );
    render.beginDraw();
    render.background( 255 );
    int geneInUse = 0;
    for( int n = 0; n < NUM_POLYGONS; n++ )
    {
      int red = (int) map( genotype.genes[geneInUse], 0.0, 1.0, 0, 256 );
      geneInUse++;
      int green = (int) map( genotype.genes[geneInUse], 0.0, 1.0, 0, 256 );
      geneInUse++;
      int blue = (int) map( genotype.genes[geneInUse], 0.0, 1.0, 0, 256 );
      geneInUse++;
      
      int translucency = (int) map( genotype.genes[geneInUse], 0.0, 1.0, 0, 256 );
      geneInUse++;

      render.fill( color( red, green, blue ), translucency );
      render.noStroke();
      
      render.beginShape();
      for( int i = 0; i < NUM_POINTS_PER_POLYGON; i++ )
      {
        float x = map( genotype.genes[geneInUse], 0.0, 1.0, 0.0, renderWidth );
        geneInUse++;
        float y = map( genotype.genes[geneInUse], 0.0, 1.0, 0.0, renderHeight );
        geneInUse++;
        render.vertex( x, y );
      }
      render.endShape();
    }
    render.endDraw();  
    return render;
  }
  
  public void calculateFitness()
  {        
    phenotype.loadPixels();
    target.loadPixels();
    
    float fitnessScore = 0;
    for( int i = 0; i < phenotype.pixels.length; i++ )
    {
      //float targetPixelRed = red( target.pixels[i] );
      //float targetPixelGreen = green( target.pixels[i] );
      //float targetPixelBlue = blue( target.pixels[i] );
    
      //float phenotypePixelRed = red( phenotype.pixels[i] );
      //float phenotypePixelGreen = green( phenotype.pixels[i] );
      //float phenotypePixelBlue = blue( phenotype.pixels[i] );
    
      float thisPixelFitnessRed = 255 - ( Math.abs( red( target.pixels[i] ) - red( phenotype.pixels[i] ) ) );
      float thisPixelFitnessGreen = 255 - ( Math.abs( green( target.pixels[i] ) - green( phenotype.pixels[i] ) ) );
      float thisPixelFitnessBlue = 255 - ( Math.abs( blue( target.pixels[i] ) - blue( phenotype.pixels[i] ) ) );

      float thisPixelFitness = thisPixelFitnessRed + thisPixelFitnessGreen + thisPixelFitnessBlue;
      
      fitnessScore += thisPixelFitness;
    }
    
    //  calculate fitness
    this.fitness = fitnessScore;
  }

  @Override
  public int compareTo( Individual anotherIndividual )
  {
    if( this.fitness > anotherIndividual.fitness )
    {
      return 1;
    }
    else if( this.fitness < anotherIndividual.fitness )
    {
      return -1;
    }
    else
    {
      return 0;
    }
  }
}