page 33020123 "Loan Risk Assesment List"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020082;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Weightage (A)"; "Weightage (A)")
                {
                }
                field("Score (B)"; "Score (B)")
                {
                }
                field("Customer Score (C)"; "Customer Score (C)")
                {
                }
                field("Weighted Score (A*C)"; "Weighted Score (A*C)")
                {
                }
                field("Total Score (A*B)"; "Total Score (A*B)")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Calculate RAM Percentage")
            {
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TotalPercentage: Decimal;
                    SumWeightedScore: Decimal;
                    SumTotalScore: Decimal;
                    LoanRiskAssesment: Record "33020082";
                    UpdateVehicleFinance: Boolean;
                    VehicleFinance: Record "33020062";
                    VehicleFinanceAPP: Record "33020073";
                begin
                    CLEAR(TotalPercentage);
                    CLEAR(SumWeightedScore);
                    CLEAR(SumTotalScore);

                    LoanRiskAssesment.RESET;
                    LoanRiskAssesment.SETRANGE("Loan No.", "Loan No.");
                    IF LoanRiskAssesment.FINDFIRST THEN BEGIN
                        REPEAT
                            SumWeightedScore += LoanRiskAssesment."Weighted Score (A*C)";
                            SumTotalScore += LoanRiskAssesment."Total Score (A*B)";
                        UNTIL LoanRiskAssesment.NEXT = 0;
                        TotalPercentage := ROUND(100 * SumWeightedScore / SumTotalScore, 2);
                        //MESSAGE('Customer Score for Risk Assesment Percentage: %1',TotalPercentage);
                    END;

                    //Agile RD june 22 2016   Update the Value of RAm percentage in the Vehicle Finance Header
                    CLEAR(UpdateVehicleFinance);    //ZM Agile June 13, 2018
                    VehicleFinance.RESET;
                    VehicleFinance.SETRANGE("Loan No.", "Loan No.");
                    IF VehicleFinance.FINDFIRST THEN BEGIN
                        IF VehicleFinance."RAM Percentage" = 0 THEN
                            UpdateVehicleFinance := TRUE
                        ELSE
                            IF VehicleFinance."RAM Percentage" = TotalPercentage THEN BEGIN
                                UpdateVehicleFinance := FALSE;
                                MESSAGE(Text001, TotalPercentage);
                            END ELSE BEGIN
                                UpdateVehicleFinance := CONFIRM(Text002, FALSE, TotalPercentage, VehicleFinance."RAM Percentage");
                            END;
                        IF UpdateVehicleFinance THEN BEGIN
                            VehicleFinance.RESET;
                            VehicleFinance.SETRANGE("Loan No.", "Loan No.");
                            IF VehicleFinance.FINDFIRST THEN BEGIN
                                VehicleFinance."RAM Percentage" := TotalPercentage;
                                //Amisha 4/23/2021
                                IF (VehicleFinance."RAM Percentage" >= 0) AND (VehicleFinance."RAM Percentage" <= 49.99) THEN
                                    VehicleFinance."Risk Grade" := VehicleFinance."Risk Grade"::Poor
                                ELSE
                                    IF (VehicleFinance."RAM Percentage" >= 50) AND (VehicleFinance."RAM Percentage" <= 59.99) THEN
                                        VehicleFinance."Risk Grade" := VehicleFinance."Risk Grade"::Doubtful
                                    ELSE
                                        IF (VehicleFinance."RAM Percentage" >= 60) AND (VehicleFinance."RAM Percentage" <= 69.99) THEN
                                            VehicleFinance."Risk Grade" := VehicleFinance."Risk Grade"::Fair
                                        ELSE
                                            IF (VehicleFinance."RAM Percentage" >= 70) AND (VehicleFinance."RAM Percentage" <= 79.99) THEN
                                                VehicleFinance."Risk Grade" := VehicleFinance."Risk Grade"::Good
                                            ELSE
                                                IF (VehicleFinance."RAM Percentage" >= 80) AND (VehicleFinance."RAM Percentage" <= 89.99) THEN
                                                    VehicleFinance."Risk Grade" := VehicleFinance."Risk Grade"::"Very good"
                                                ELSE
                                                    VehicleFinance."Risk Grade" := VehicleFinance."Risk Grade"::Excellent;
                                //Ami*
                                VehicleFinance.MODIFY;


                                MESSAGE(Text003, TotalPercentage);
                            END;
                        END;
                    END;
                    //Agile RD june 22 2016

                    //ZM Aug 11, 2016
                    CLEAR(UpdateVehicleFinance);    //ZM Agile June 13, 2018
                    VehicleFinanceAPP.RESET;
                    VehicleFinanceAPP.SETRANGE("Application No.", "Loan No.");
                    IF VehicleFinanceAPP.FINDFIRST THEN BEGIN
                        IF VehicleFinanceAPP."RAM Percentage" = 0 THEN
                            UpdateVehicleFinance := TRUE
                        ELSE
                            IF VehicleFinanceAPP."RAM Percentage" = TotalPercentage THEN BEGIN
                                UpdateVehicleFinance := FALSE;
                                MESSAGE(Text001, TotalPercentage);
                            END ELSE BEGIN
                                UpdateVehicleFinance := CONFIRM(Text002, FALSE, TotalPercentage, VehicleFinanceAPP."RAM Percentage");
                            END;
                        IF UpdateVehicleFinance THEN BEGIN
                            VehicleFinanceAPP.RESET;
                            VehicleFinanceAPP.SETRANGE("Application No.", "Loan No.");
                            IF VehicleFinanceAPP.FINDFIRST THEN BEGIN
                                VehicleFinanceAPP."RAM Percentage" := TotalPercentage;
                                //Amisha 4/23/2021
                                IF (VehicleFinanceAPP."RAM Percentage" >= 0) AND (VehicleFinanceAPP."RAM Percentage" <= 49.99) THEN
                                    VehicleFinanceAPP."Risk Grade" := VehicleFinanceAPP."Risk Grade"::Poor
                                ELSE
                                    IF (VehicleFinanceAPP."RAM Percentage" >= 50) AND (VehicleFinanceAPP."RAM Percentage" <= 59.99) THEN
                                        VehicleFinanceAPP."Risk Grade" := VehicleFinanceAPP."Risk Grade"::Doubtful
                                    ELSE
                                        IF (VehicleFinanceAPP."RAM Percentage" >= 60) AND (VehicleFinanceAPP."RAM Percentage" <= 69.99) THEN
                                            VehicleFinanceAPP."Risk Grade" := VehicleFinanceAPP."Risk Grade"::Fair
                                        ELSE
                                            IF (VehicleFinanceAPP."RAM Percentage" >= 70) AND (VehicleFinanceAPP."RAM Percentage" <= 79.99) THEN
                                                VehicleFinanceAPP."Risk Grade" := VehicleFinanceAPP."Risk Grade"::Good
                                            ELSE
                                                IF (VehicleFinance."RAM Percentage" >= 80) AND (VehicleFinance."RAM Percentage" <= 89.99) THEN
                                                    VehicleFinanceAPP."Risk Grade" := VehicleFinanceAPP."Risk Grade"::"Very good"
                                                ELSE
                                                    VehicleFinanceAPP."Risk Grade" := VehicleFinanceAPP."Risk Grade"::Excellent;
                                //Ami*
                                //VehicleFinance.MODIFY;
                                //Ami*
                                VehicleFinanceAPP.MODIFY;
                                MESSAGE(Text003, TotalPercentage);
                            END;
                        END;
                    END
                    //ZM Aug 11, 2016;
                end;
            }
        }
    }

    var
        Text001: Label 'Customer Score for Risk Assessment Percentage: %1';
        Text002: Label 'Current Score for Risk Assessment Percentage: %1 but it''s document value is %2. Do you want to update the document value with the calculated value?';
        Text003: Label 'Current Score for Risk Assessment Percentage has been updated to : %1 ';
        IsVisibleVF: Boolean;
        IsVisibleVFApp: Boolean;
        VehicleFinance: Record "33020062";

    [Scope('Internal')]
    procedure IsCalculateRAMPer(LocalIsVisibleVF: Boolean)
    begin
        IsVisibleVF := LocalIsVisibleVF;
    end;

    [Scope('Internal')]
    procedure IsCalculateRAMPerApp(LocalIsVisibleVFApp: Boolean)
    begin
        IsVisibleVFApp := LocalIsVisibleVFApp;
    end;
}

