public class DNA
{
  float[] genes;
  
  public DNA()
  {
    genes = new float[ Individual.NUM_GENES ];

    for( int i = 0; i < genes.length; i++ )
    {
      genes[i] = randy.nextFloat();
    }
  }
  
  public void mutate()
  {
    mediumMutate();
  }
  
  public void mediumMutate()
  {
    int randomGeneIndex = randy.nextInt( genes.length );
    genes[randomGeneIndex] = randy.nextFloat();
  }
  
  public void softMutate()
  {    
    int randomGeneIndex = randy.nextInt( genes.length );
    genes[randomGeneIndex] += (randy.nextFloat() - 1);
    genes[randomGeneIndex] = clamp( genes[randomGeneIndex], 0, 1);
  }
  
  public void gaussianMutate()
  {
    int randomGeneIndex = randy.nextInt( genes.length );
    genes[randomGeneIndex] += ( randomGaussian() - 1 );
    genes[randomGeneIndex] = clamp( genes[randomGeneIndex], 0, 1);
  }
  
  public void hardMutate()
  {
    for( int i = 0; i < genes.length; i++ )
    {
      genes[i] = randy.nextFloat();
    }
  }
  
  public float randomlyIncrementOrDecrement( float number )
  {
    float chance = randy.nextFloat();
    if( chance > 0.5 )
    {
      return number + 1;
    }
    else
    {
      return number - 1;
    }
  }
  
}