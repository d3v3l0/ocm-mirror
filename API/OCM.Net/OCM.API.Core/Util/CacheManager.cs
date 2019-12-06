using OCM.API.Common;
using OCM.API.Common.Model.Extended;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OCM.Core.Data
{
    public enum CacheUpdateStrategy
    {
        All,
        Modified,
        Incremental
    }

    public class CacheManager
    {
        public static OCM.API.Common.Model.ChargePoint GetPOI(int id)
        {
            try
            {
                return CacheProviderMongoDB.DefaultInstance.GetPOI(id);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static OCM.API.Common.Model.CoreReferenceData GetCoreReferenceData()
        {
            try
            {
                return CacheProviderMongoDB.DefaultInstance.GetCoreReferenceData();
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static List<OCM.API.Common.Model.ChargePoint> GetPOIList(APIRequestParams filter)
        {
            try
            {
                return CacheProviderMongoDB.DefaultInstance.GetPOIList(filter);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static void InitCaching(Settings.CoreSettings settings)
        {
            CacheProviderMongoDB.CreateDefaultInstance(settings);
        }
        public async static Task<MirrorStatus> RefreshCachedData(CacheUpdateStrategy updateStrategy = CacheUpdateStrategy.Modified)
        {
            try
            {
                return await CacheProviderMongoDB.DefaultInstance.PopulatePOIMirror(updateStrategy);
            }
            catch (Exception exp)
            {
                return new MirrorStatus { Description = exp.ToString(), StatusCode = System.Net.HttpStatusCode.ExpectationFailed };
            }
        }

        public async static Task<MirrorStatus> GetCacheStatus(bool includeDupeCheck = false)
        {
            try
            {
                return await Task.Run<MirrorStatus>(() =>
                {
                    return CacheProviderMongoDB.DefaultInstance.GetMirrorStatus(includeDupeCheck, true);
                });
            }
            catch (Exception)
            {
                return null;
            }
        }

        public async static Task<MirrorStatus> RefreshCachedPOI(int poiId)
        {
            if (poiId == 0)
            {
                return await RefreshCachedData();
            }

            try
            {
                return await CacheProviderMongoDB.DefaultInstance.PopulatePOIMirror(CacheUpdateStrategy.Modified);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static List<CountryExtendedInfo> GetExtendedCountryInfo()
        {
            return CacheProviderMongoDB.DefaultInstance.GetExtendedCountryInfo();
        }
    }
}