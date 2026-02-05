#!/usr/bin/env python3
"""
Plot time series data from oyster simulation CSV files
Each column is plotted separately
"""

import pandas as pd
import matplotlib.pyplot as plt
import os
from pathlib import Path

def plot_csv_timeseries(output_dir=None, plot_output_dir=None):
    """
    Plot time series data from oyster CSV files
    
    Parameters:
    -----------
    output_dir : str
        Directory containing CSV files (default: output)
    plot_output_dir : str
        Directory to save plots (default: output_dir/plots)
    """
    
    if output_dir is None:
        output_dir = 'output'
    
    if plot_output_dir is None:
        plot_output_dir = os.path.join(output_dir, 'plots')
    
    # Create output directory for plots
    os.makedirs(plot_output_dir, exist_ok=True)
    
    # Get all CSV files
    csv_files = [f for f in os.listdir(output_dir) if f.endswith('.csv')]
    
    if not csv_files:
        print(f"No CSV files found in {output_dir}")
        return
    
    print(f"Found {len(csv_files)} CSV files")
    print(f"Output directory: {plot_output_dir}\n")
    
    # Process each CSV file
    for csv_file in sorted(csv_files):
        csv_path = os.path.join(output_dir, csv_file)
        
        # Read the CSV file
        df = pd.read_csv(csv_path)
        
        # Clean column names (remove leading/trailing spaces)
        df.columns = df.columns.str.strip()
        
        # Get the time column (usually the first column)
        time_col = df.columns[0]
        
        # Convert time column to numeric if needed
        df[time_col] = pd.to_numeric(df[time_col], errors='coerce')
        
        print(f"Processing: {csv_file}")
        print(f"  Columns: {len(df.columns)}")
        print(f"  Rows: {len(df)}")
        
        # Plot each column (except time)
        plot_count = 0
        for col in df.columns[1:]:
            # Try to convert to numeric
            try:
                df[col] = pd.to_numeric(df[col], errors='coerce')
            except:
                continue
            
            # Skip if all values are NaN
            if df[col].isna().all():
                continue
            
            # Skip if column contains non-numeric data
            try:
                fig, ax = plt.subplots(figsize=(10, 5))
                ax.plot(df[time_col], df[col], linewidth=1)
            except Exception as e:
                print(f"  Warning: Could not plot '{col}': {e}")
                plt.close(fig)
                continue
            
            ax.set_xlabel(time_col)
            ax.set_ylabel(col)
            ax.set_title(f'{csv_file.replace(".csv", "")} - {col}')
            ax.grid(True, alpha=0.3)
            
            # Save the plot
            filename_safe = f"{csv_file.replace('.csv', '')}_{col.replace('/', '_').replace(' ', '_')}.png"
            plt.savefig(os.path.join(plot_output_dir, filename_safe), dpi=100, bbox_inches='tight')
            plt.close(fig)
            
            plot_count += 1
        
        print(f"  Plotted: {plot_count} columns\n")

if __name__ == '__main__':
    plot_csv_timeseries()
