dotnet
{
    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.IO.Path"; "Path")
        {
        }

        type("System.IO.Directory"; "Directory")
        {
        }

        type("System.String"; "String")
        {
        }
    }

    assembly("Microsoft.Dynamics.Nav.Client.BusinessChart.Model")
    {
        Version = '10.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = '31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint"; "BusinessChartDataPoint")
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
