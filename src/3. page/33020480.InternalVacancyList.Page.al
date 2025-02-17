page 33020480 "Internal Vacancy List"
{
    CardPageID = "Internal Vacancy Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table33020415;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("For Job Title Code"; "For Job Title Code")
                {
                }
                field("For Job Title"; "For Job Title")
                {
                }
                field("Posted By"; "Posted By")
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field("Closed Date"; "Closed Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000010>")
            {
                Caption = 'Show Applicant';
                Image = ExportSalesPerson;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                RunObject = Page 33020483;
                RunPageLink = Vacancy Code=FIELD(Vacancy Code);
            }
            action("Show Applicant for Written Exam")
            {
                Caption = 'Show Applicant for Written Exam';
                Image = ExportSalesPerson;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 33020484;
                                RunPageLink = Vacancy Code=FIELD(Vacancy Code),
                              Select for Written Exam=CONST(Yes);
            }
            action("<Action1000000011>")
            {
                Caption = 'Show Applicant for Interview';
                Image = ExportSalesPerson;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 33020485;
                                RunPageLink = Vacancy Code=FIELD(Vacancy Code),
                              Select for Written Exam=CONST(Yes),
                              Select for Interview=CONST(Yes);
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text001: Label 'Do you want to Close this Vacancy?';
}

