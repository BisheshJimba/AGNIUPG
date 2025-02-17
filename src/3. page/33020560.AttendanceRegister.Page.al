page 33020560 "Attendance Register"
{
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Attendance';
    SourceTable = Table33020557;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Journal Template Name"; "Journal Template Name")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Attendance From"; "Attendance From")
                {
                }
                field("Attendance To"; "Attendance To")
                {
                }
                field("Present Days"; "Present Days")
                {
                }
                field("Absent Days"; "Absent Days")
                {
                }
                field("Paid Days"; "Paid Days")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Total Holidays"; "Total Holidays")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Ledger Entries")
            {
                Caption = 'Ledger Entries';
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020561;
                RunPageLink = Journal Template Name=FIELD(Journal Template Name),
                              Journal Batch Name=FIELD(Journal Batch Name),
                              No.=FIELD(No.),
                              Journal Line No.=FIELD(Line No.),
                              Employee No.=FIELD(Employee No.);
            }
        }
    }
}

