page 25006187 "Service Comment Sheet EDMS"
{
    // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00
    //   Changed PageType property from List to Card (for editing on lookup)
    // 
    // 27.03.2014 Elva Baltic P18 #RX029 MMG7.00
    //   Added field "Satisfaction"

    AutoSplitKey = true;
    Caption = 'Service Comment Sheet EDMS';
    DataCaptionFields = Type, "No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table25006148;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date; Date)
                {
                    Visible = false;
                }
                field("Customer Complaint"; "Customer Complaint")
                {
                }
                field("Immediate and Further Action"; "Immediate and Further Action")
                {
                }
                field("Root Cause"; "Root Cause")
                {
                }
                field("Jobs Done"; "Jobs Done")
                {
                }
                field("User ID"; "User ID")
                {
                    Visible = false;
                }
                field("Comment Type Code"; "Comment Type Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;
}

