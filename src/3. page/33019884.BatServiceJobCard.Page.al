page 33019884 "Bat-Service Job Card"
{
    Caption = 'Job Card';
    PageType = Card;
    SourceTable = Table33019884;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Job Card No."; "Job Card No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Battery Serial No."; "Battery Serial No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Sales Date"; "Sales Date")
                {

                    trigger OnValidate()
                    begin
                        //Code to break sales date into year,month,day
                        GblSalesYear := DATE2DMY(GblJobCardEntry."Sales Date", 3);
                        GblSalesMonth := DATE2DMY(GblJobCardEntry."Sales Date", 2);
                        GblSalesDay := DATE2DMY(GblJobCardEntry."Sales Date", 1);

                        //Code to break current date into year,month,day
                        GblCurYear := DATE2DMY(TODAY, 3);
                        GblCurMonth := DATE2DMY(TODAY, 2);
                        GblCurDay := DATE2DMY(TODAY, 1);

                        GblDiffYear := GblCurYear - GblSalesYear;

                        //Message('%1',GblDiffYear);
                    end;
                }
                field("Warranty Date"; "Warranty Date")
                {

                    trigger OnValidate()
                    begin
                        IF "Warranty Date" <> 0DT THEN BEGIN
                            "Job Start Date" := "Warranty Date";
                        END;
                    end;
                }
                field(Month; Month)
                {
                }
                field("Job Start Date"; "Job Start Date")
                {
                }
                field("Promise Date"; "Promise Date")
                {
                }
                field("Job End Date"; "Job End Date")
                {
                }
                field("Customer Agent No."; "Customer Agent No.")
                {
                }
                field("Customer Agent Name"; "Customer Agent Name")
                {
                }
                field("Bill to Agent"; "Bill to Agent")
                {
                }
            }
            group("Battery Reference")
            {
                field("Battery Part No."; "Battery Part No.")
                {
                }
                field("Battery Description"; "Battery Description")
                {
                    Editable = false;
                }
                field("Battery Type"; "Battery Type")
                {
                    Editable = false;
                }
                field(MFG; MFG)
                {
                }
                field("Vehicle Model"; "Vehicle Model")
                {
                }
                field("Vehicle Type"; "Vehicle Type")
                {
                }
                field(Registration; Registration)
                {
                }
                field("OE/Trd"; "OE/Trd")
                {

                    trigger OnValidate()
                    begin
                        IF "OE/Trd" = "OE/Trd"::TR THEN
                            ShowMe := TRUE
                        ELSE
                            ShowMe := FALSE;
                    end;
                }
                field("KM."; "KM.")
                {
                    Enabled = ShowMe;
                }
                field("Serv Batt Type"; "Serv Batt Type")
                {
                }
                field("Gua.Card"; "Gua.Card")
                {
                }
                field("Replaced Part"; "Replaced Part")
                {
                }
                field("Rep. Batt. Serial"; "Rep. Batt. Serial")
                {
                }
                field(Recharged; Recharged)
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
            group("Job Details")
            {
                field("Claim No."; "Claim No.")
                {
                }
                field("Issue No."; "Issue No.")
                {
                }
                field(Bill; Bill)
                {
                }
                field(GRN; GRN)
                {
                }
                field("Job Closed"; "Job Closed")
                {
                }
                field(Date; Date)
                {
                }
            }
            group(Others)
            {
                field("Internal Comment"; "Internal Comment")
                {
                }
                field("Job For"; "Job For")
                {
                }
                field("Transfer Ref."; "Transfer Ref.")
                {
                }
                field("Cut Piece Received"; "Cut Piece Received")
                {
                }
                field("Created By"; "Created By")
                {
                }
                field("Updated By"; "Updated By")
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

    var
        [InDataSet]
        ShowMe: Boolean;
        GblSalesYear: Integer;
        GblSalesMonth: Integer;
        GblSalesDay: Integer;
        GblCurYear: Integer;
        GblCurMonth: Integer;
        GblCurDay: Integer;
        GblJobCardEntry: Record "33019884";
        GblDiffYear: Integer;
}

