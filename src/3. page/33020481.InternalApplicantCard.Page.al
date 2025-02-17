page 33020481 "Internal-Applicant Card"
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

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("Post Applied For"; "Post Applied For")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Date of Birth"; "Date of Birth")
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field(Gender; Gender)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field("Citizenship No."; "Citizenship No.")
                {
                }
                group("Permanent Address")
                {
                    Caption = 'Permanent Address';
                    field(P_WardNo; P_WardNo)
                    {
                        Caption = 'WardNo';
                    }
                    field(P_VDC_NP; P_VDC_NP)
                    {
                        Caption = 'VDC_NP';
                    }
                    field(P_District; P_District)
                    {
                        Caption = 'District';
                    }
                }
                group("Temporary Address")
                {
                    Caption = 'Temporary Address';
                    field(T_WardNo; T_WardNo)
                    {
                        Caption = 'WardNo';
                    }
                    field(T_VDC_NP; T_VDC_NP)
                    {
                        Caption = 'VDC_NP';
                    }
                    field(T_District; T_District)
                    {
                        Caption = 'District';
                    }
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field(Language; Language)
                {
                }
                field("Computer Knowledge"; "Computer Knowledge")
                {
                }
                field("Driving License"; "Driving License")
                {
                }
                field(Vehicle; Vehicle)
                {
                }
            }
            part(; 33020487)
            {
                SubPageLink = Applicant No.=FIELD(Applicant No.),
                              Employee Code=FIELD(Employee Code);
            }
            part(;33020488)
            {
                SubPageLink = Applicant No.=FIELD(Applicant No.),
                              Employee Code=FIELD(Employee Code);
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
         //PAGE.RUNMODAL();
    end;
}

