//
//  XGYImageModel.m
//  XGYPhotoBrowse
//
//  Created by guoyong xu on 2019/4/15.
//  Copyright © 2019年 guoyong xu. All rights reserved.
//

#import "XGYImageModel.h"

@implementation XGYImageModel
+ (NSArray *)imageURLArray
{
    NSArray *images =  @[@"http://wx1.sinaimg.cn/orj360/006iYHC8gy1ftxoby5uo7j30qo5flkjm.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                         @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3018855160,704150459&fm=26&gp=0.jpg",
                         @"https://upload-images.jianshu.io/upload_images/1747081-4e5000cdf6dccd69.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/230",
                         @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2496785309,3825678859&fm=26&gp=0.jpg",
                         @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3207781657,3460758070&fm=26&gp=0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=5f43be656e133792c95c4db3d18263b7&imgtype=0&src=http%3A%2F%2Fimg000.hc360.cn%2Fg7%2FM00%2F5E%2F4B%2FwKhQtFQClMmEL-LRAAAAAF93r9M154.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=a03b1051244aa3a4f58ecdd196cddb8d&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190305%2F676b2255f4764d939ff67e17f969a270.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618571&di=4a9415a30f7029f45c325bea790e7d11&imgtype=0&src=http%3A%2F%2Fphoto.tuchong.com%2F15557%2Ff%2F163968.jpg",
                         @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1709195029,412005348&fm=26&gp=0.jpg",
                         @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3948394334,4102485975&fm=15&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1792586839,4224858343&fm=26&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2470359337,596800743&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2532879260,2161329853&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1446324415,1974586192&fm=27&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3885823919,3995537631&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=50078916,3968991826&fm=27&gp=0.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1237732315,4262665329&fm=26&gp=0.jpg",
                         @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3207781657,3460758070&fm=26&gp=0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=5f43be656e133792c95c4db3d18263b7&imgtype=0&src=http%3A%2F%2Fimg000.hc360.cn%2Fg7%2FM00%2F5E%2F4B%2FwKhQtFQClMmEL-LRAAAAAF93r9M154.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2431494632,240569196&fm=26&gp=0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=a03b1051244aa3a4f58ecdd196cddb8d&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190305%2F676b2255f4764d939ff67e17f969a270.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618571&di=4a9415a30f7029f45c325bea790e7d11&imgtype=0&src=http%3A%2F%2Fphoto.tuchong.com%2F15557%2Ff%2F163968.jpg",
                         @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3948394334,4102485975&fm=15&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2470359337,596800743&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2532879260,2161329853&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1446324415,1974586192&fm=27&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3885823919,3995537631&fm=27&gp=0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555490075113&di=2c81ba4ac83c489c156a4d1756c61132&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160411%2Fd061d75eede04c66b447099ec5f866ff_th.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2470240801,636864507&fm=26&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=50078916,3968991826&fm=27&gp=0.jpg",
                         @"http://wx1.sinaimg.cn/orj360/006iYHC8gy1ftxoby5uo7j30qo5flkjm.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                         @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1922925079,1791476498&fm=26&gp=0.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                         @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3207781657,3460758070&fm=26&gp=0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=5f43be656e133792c95c4db3d18263b7&imgtype=0&src=http%3A%2F%2Fimg000.hc360.cn%2Fg7%2FM00%2F5E%2F4B%2FwKhQtFQClMmEL-LRAAAAAF93r9M154.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=a03b1051244aa3a4f58ecdd196cddb8d&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190305%2F676b2255f4764d939ff67e17f969a270.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618571&di=4a9415a30f7029f45c325bea790e7d11&imgtype=0&src=http%3A%2F%2Fphoto.tuchong.com%2F15557%2Ff%2F163968.jpg",
                         @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3948394334,4102485975&fm=15&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2470359337,596800743&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2532879260,2161329853&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1446324415,1974586192&fm=27&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3885823919,3995537631&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=50078916,3968991826&fm=27&gp=0.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                         @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                         @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3207781657,3460758070&fm=26&gp=0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=5f43be656e133792c95c4db3d18263b7&imgtype=0&src=http%3A%2F%2Fimg000.hc360.cn%2Fg7%2FM00%2F5E%2F4B%2FwKhQtFQClMmEL-LRAAAAAF93r9M154.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618572&di=a03b1051244aa3a4f58ecdd196cddb8d&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190305%2F676b2255f4764d939ff67e17f969a270.jpeg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555070618571&di=4a9415a30f7029f45c325bea790e7d11&imgtype=0&src=http%3A%2F%2Fphoto.tuchong.com%2F15557%2Ff%2F163968.jpg",
                         @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3948394334,4102485975&fm=15&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2470359337,596800743&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2532879260,2161329853&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1446324415,1974586192&fm=27&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3885823919,3995537631&fm=27&gp=0.jpg",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=50078916,3968991826&fm=27&gp=0.jpg"
                         ];
    return images;
}
@end
