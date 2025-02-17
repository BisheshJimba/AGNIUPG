page 33020189 "Ins. Memo Cancellation History"
{
    PageType = List;
    SourceTable = Table33020168;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Chesis No."; "Chesis No.")
                {
                }
                field("Reason for Cancellation"; "Reason for Cancellation")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159016>")
            {
                Caption = 'Cancel Insurance';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    OK := CONFIRM('Are you sure to cancel this insurance policy?');
                    IF NOT OK THEN
                        EXIT;

                    TESTFIELD("Reason for Cancellation");
                    "Date of cancellation" := TODAY;
                    "Cancelled By" := USERID;
                    InsMemoLine.RESET;
                    InsMemoLine.SETRANGE("Reference No.", "Insurance Memo No.");
                    InsMemoLine.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
                    IF InsMemoLine.FINDFIRST THEN BEGIN
                        InsMemoLine.Canceled := TRUE;
                        InsMemoLine.MODIFY;
                        //Sipradi-YS BEGIN * 8.17.2012
                        InsMemoHeader.RESET;
                        InsMemoHeader.SETRANGE("Reference No.", InsMemoLine."Reference No.");
                        IF InsMemoHeader.FINDFIRST THEN;
                        VehicleInsurance.RESET;
                        VehicleInsurance.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
                        VehicleInsurance.SETRANGE(Cancelled, FALSE);
                        VehicleInsurance.SETRANGE("Ins. Company Code", InsMemoHeader."Ins. Company Code");
                        IF VehicleInsurance.FINDFIRST THEN BEGIN
                            VehicleInsurance.Cancelled := TRUE;
                            VehicleInsurance."Cancellation Date" := TODAY;
                            VehicleInsurance."Reason for Cancellation" := "Reason for Cancellation";
                            VehicleInsurance."Proceed for Ins. Payment" := FALSE;
                            VehicleInsurance."Payment Memo Generated" := FALSE;
                            VehicleInsurance.MODIFY;


                            /*
                              InsPaymentMemoLine.RESET;
                              InsPaymentMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                              InsPaymentMemoLine.SETRANGE("Insurance Policy No.",VehicleInsurance."Insurance Policy No.");
                              IF InsPaymentMemoLine.FINDFIRST THEN BEGIN
                                InsPaymentMemoLine.Cancelled := TRUE;
                                InsPaymentMemoLine."Cancellation Date" := TODAY;
                                InsPaymentMemoLine."Reason for Cancellation" := "Reason for Cancellation";
                                InsPaymentMemoLine.MODIFY;
                              END;
                            */
                        END;
                    END;
                    //Sipradi-YS END

                end;
            }
        }
    }

    var
        InsMemoLine: Record "33020166";
        VehicleInsurance: Record "25006033";
        InsPaymentMemoLine: Record "33020170";
        InsMemoHeader: Record "33020165";
        OK: Boolean;
}

