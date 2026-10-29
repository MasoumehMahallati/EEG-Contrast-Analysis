function stats = get_sig_stats(long_data, baseline_data, alpha, q_fdr, minRun, nPerm)

% long_data      : [subjects x time]
% baseline_data  : [subjects x baseline_time]
% alpha          : مثلا 0.05 (برای تست خام)
% q_fdr          : مثلا 0.05 یا 0.1
% minRun         : حداقل طول خوشه (مثلا 5)
% nPerm          : تعداد permutation (مثلا 1000)

T = size(long_data,2);

mean_baseline = mean(baseline_data, 2);

p_raw = nan(1,T);
for t = 1:T
    p_raw(t) = signrank(long_data(:,t), mean_baseline);
end

sig_raw = p_raw < alpha;

% ---------- FDR (Benjamini-Hochberg)
p_fdr = mafdr(p_raw, 'BHFDR', true);
sig_fdr = p_fdr < q_fdr;

% ---------- Cluster-based permutation
maxCluster_perm = zeros(1, nPerm);

diff_data = long_data - mean_baseline;

for perm = 1:nPerm
    signs = (rand(size(mean_baseline)) > 0.5)*2 - 1;   % ±1 برای هر سابجکت
    diff_perm = diff_data .* signs;

    p_perm = nan(1,T);
    for t = 1:T
        p_perm(t) = signrank(diff_perm(:,t));
    end

    sig_perm = p_perm < alpha;

    % طول بزرگ‌ترین خوشه
    i = 1;
    max_len = 0;
    while i <= T
        if sig_perm(i)
            start_i = i;
            while i <= T && sig_perm(i)
                i = i + 1;
            end
            cluster_len = i - start_i;
            max_len = max(max_len, cluster_len);
        else
            i = i + 1;
        end
    end
    maxCluster_perm(perm) = max_len;
end

cluster_thresh = prctile(maxCluster_perm, 95);

sig_cluster = false(1,T);
i = 1;
while i <= T
    if sig_raw(i)
        start_i = i;
        while i <= T && sig_raw(i)
            i = i + 1;
        end
        end_i = i - 1;
        cluster_len = end_i - start_i + 1;

        if cluster_len >= max(cluster_thresh, minRun)
            sig_cluster(start_i:end_i) = true;
        end
    else
        i = i + 1;
    end
end

% ---------- خروجی‌ها
stats.p_raw = p_raw;
stats.sig_raw = sig_raw;

stats.p_fdr = p_fdr;
stats.sig_fdr = sig_fdr;

stats.sig_cluster = sig_cluster;
stats.cluster_thresh = cluster_thresh;
stats.maxCluster_perm = maxCluster_perm;

end