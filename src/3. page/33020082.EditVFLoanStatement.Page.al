page 33020082 "Edit VF Loan Statement"
{
    PageType = Document;
    SourceTable = Table33020062;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan No."; "Loan No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Vehicle No."; "Vehicle No.")
                {
                }
                part(; 33020076)
                {
                    SubPageLink = Loan No.=FIELD(Loan No.);
                }
            }
        }
    }

    actions
    {
    }
}

