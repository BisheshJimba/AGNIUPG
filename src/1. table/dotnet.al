dotnet
{
    assembly("mscorlib")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.IO.Path"; "Path")
        {
        }

        type("System.IO.Directory"; "Directory")
        {
        }
    }

    assembly("")
    {
        type(""; "")
        {
        }
    }

}
