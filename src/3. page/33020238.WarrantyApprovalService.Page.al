page 33020238 "Warranty Approval - Service"
{
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table25006146;
    SourceTableView = SORTING(Document Type, Document No., Line No.);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Warranty Claim No."; "Warranty Claim No.")
                {
                    Caption = 'Claim No.';
                }
                field("Job Type"; "Job Type")
                {
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Warranty Approved"; "Warranty Approved")
                {
                    Caption = 'Approved';
                }
                field("Approved Date"; "Approved Date")
                {
                    Editable = false;
                }
                field("Warranty Status"; "Warranty Status")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendAppRequest)
            {
                Caption = '&Send Approval Request';

                trigger OnAction()
                begin
                    //InsertWarrantyApproval(rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETRANGE("Document Type","Document Type"::Order);
        //SETRANGE("Document No.","Document No.");
        //setrange("Need Approval",true);
        //SETRANGE("Warranty Claim No.",'<>''');
    end;
}

