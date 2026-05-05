import pandas as pd

# Step 1: Load the CSV files
users = pd.read_csv("../DATA/users.csv")
events = pd.read_csv("../DATA/events.csv")
transactions = pd.read_csv("../DATA/transactions_food.csv") # change to transactions_food.csv if you renamed it

# Step 2: Convert date columns into proper date format
events["event_date"] = pd.to_datetime(events["event_date"])
transactions["transaction_date"] = pd.to_datetime(transactions["transaction_date"])

# Step 3: Join transactions with events using user_id
# This adds each user's move date to their transactions
data = transactions.merge(events, on="user_id", how="left")

# Step 4: Label each transaction as Before Move or After Move
data["period"] = data.apply(
    lambda row: "Before Move" if row["transaction_date"] < row["event_date"] else "After Move",
    axis=1
)

# Step 5: Add user names to the data
data = data.merge(users, on="user_id", how="left")

# Step 6: Calculate total spending before and after moving
summary = data.groupby(["user_id", "name", "period"])["amount"].sum().reset_index()

print("\nFood spending before and after moving:")
print(summary)

# Step 7: Make the result easier to compare
comparison = summary.pivot(
    index=["user_id", "name"],
    columns="period",
    values="amount"
).reset_index()

# Fill empty values with 0
comparison = comparison.fillna(0)

# Step 8: Calculate spending change
comparison["spending_change"] = comparison["After Move"] - comparison["Before Move"]

# Step 9: Calculate percentage change
comparison["percentage_change"] = (
    comparison["spending_change"] / comparison["Before Move"] * 100
).round(2)

print("\nBefore vs After comparison:")
print(comparison)

# Step 10: Print simple insights
print("\nSimple Insights:")

for _, row in comparison.iterrows():
    name = row["name"]
    change = row["spending_change"]
    percent = row["percentage_change"]

    if change > 0:
        print(f"{name}'s food spending increased by ${change} after moving ({percent}%).")
    elif change < 0:
        print(f"{name}'s food spending decreased by ${abs(change)} after moving ({abs(percent)}%).")
    else:
        print(f"{name}'s food spending stayed the same after moving.")

# Step 11: Save results to CSV
output_path = "../DATA/analysis_output.csv"
comparison.to_csv(output_path, index=False)

print(f"\nResults saved to {output_path}")