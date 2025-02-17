page 33020241 "Vehicle Scheme Register Card"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = Table33020240;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("VIN Code"; "VIN Code")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field(Period; Period)
                {

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime("Start Date", 0T);
                        //"Valid Until" := "Start Date" + Period;
                    end;
                }
                field("Valid Until"; "Valid Until")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        "Scheme Type" := "Scheme Type"::AMC;
    end;

    var
        DateTimeMgt: Codeunit "25006012";
        StartDateTime: Decimal;
}

