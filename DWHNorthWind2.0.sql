Data Source=DESKTOP-5K5MLOJ;Initial Catalog=DWHNorthwindOrders;Integrated Security=True;TrustServerCertificate=True;

public override void Input0_ProcessInputRow(Input0Buffer Row)
{
    LoadCustomers(Row.CustomerID,
                  Row.CustomerName, 
                  Row.City, 
                  Row.Country, 
                  Row.Phone)
                  .GetAwaiter()
                  .GetResult();
}


public async Task LoadCustomers(string CustomerID, 
                   string CustomerName, 
                   string City, 
                   string Country,
                   string Phone) 
{
    try
    {
        using (SqlConnection connection = new SqlConnection(this.Variables.connstring))
        {
            connection.Open();

            using (SqlCommand cmd = new SqlCommand("dbo.sp_Insert_DimCustomer", connection))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@CustomerID", CustomerID);
                cmd.Parameters.AddWithValue("@CustomerName", CustomerName);
                cmd.Parameters.AddWithValue("@City", City);
                cmd.Parameters.AddWithValue("@Country", Country);
                cmd.Parameters.AddWithValue("@Phone", Phone);

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error: {ex.Message}");
    }
}

Data Source=DESKTOP-5K5MLOJ;Initial Catalog=DWHNorthwindOrders;Integrated Security=True;TrustServerCertificate=True;
Server=DESKTOP-5G79S3D;Database=DWHNorthwindOrders;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True