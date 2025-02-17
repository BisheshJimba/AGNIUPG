page 33020486 "Internal App-Interview Card"
{
    PageType = Card;
    SourceTable = Table33020416;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Applicant No."; "Applicant No.")
                {
                    Editable = false;
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                    Editable = false;
                }
                field("Post Applied For"; "Post Applied For")
                {
                    Editable = false;
                }
                field("Employee Code"; "Employee Code")
                {
                    Editable = false;
                }
                field("First Name"; "First Name")
                {
                    Editable = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    Editable = false;
                }
                field("Written Marks"; "Written Marks")
                {
                    Editable = false;
                }
            }
            part(; 33020489)
            {
                SubPageLink = Applicant No.=FIELD(Applicant No.),
                              Vacancy Code=FIELD(Vacancy Code);
            }
        }
    }

    actions
    {
    }
}

