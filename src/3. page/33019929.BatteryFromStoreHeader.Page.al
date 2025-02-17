page 33019929 "Battery From Store Header"
{
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = Table33019897;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
            }
            part(; 33019928)
            {
                SubPageLink = No.=FIELD(No.);
            }
            group("Remarks ")
            {
                field(Remarks; Remarks)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

